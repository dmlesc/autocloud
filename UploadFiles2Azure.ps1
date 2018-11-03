Param(
  [string]$build,
  [string]$subscriptionName,
  [string]$workspace
)

$ErrorActionPreference = "Stop"

Write-Host "workspace:" $workspace

$azurePublishSettingsFile = "c:\pathto\credentials.publishsettings"
$storageAccountName = "storage" + $subscriptionName.ToLower()
Write-Host "storageAccountName:" $storageAccountName

Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"
Import-AzurePublishSettingsFile $azurePublishSettingsFile

$VerbosePreference = "Continue"

Select-AzureSubscription -SubscriptionName $subscriptionName

$container = "container"
$folder = $workspace + "\folder\"
$files = Get-ChildItem $folder

$context = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey key
$storageContainer = Get-AzureStorageContainer -Context $context -Name $container -ErrorAction SilentlyContinue -ErrorVariable error
if ($error[0]) {
   Write-Host "==================== Creating container $container  ===================="  
   New-AzureStorageContainer -Name $container
}

foreach ($file in $files) {
   Write-Host "Adding file:" $file.FullName
   $blob = $build + "/" + $file.Name
   Set-AzureStorageBlobContent -Container $container -File $file.FullName -Blob $blob -Context $context
}
