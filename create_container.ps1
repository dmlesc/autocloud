$scriptPath = "C:\azure\"
$azurePublishSettingsFile = $scriptPath + "TEST-credentials.publishsettings"
$storageAccountName = "name"
$subscriptionName = "TEST"

$container = "container"
$containerFilesPath = $scriptPath + $container
$containerFiles = Get-ChildItem $containerFilesPath
$blob = ""

Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"
Import-AzurePublishSettingsFile $azurePublishSettingsFile

$VerbosePreference = "Continue"

$context = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey key
$storageContainer = Get-AzureStorageContainer -Context $context -Name $container -ErrorAction SilentlyContinue -ErrorVariable error
if ($error[0]) {
   Write-Host "==================== Creating container $container  ===================="  
   New-AzureStorageContainer -Name $container
}

foreach ($file in $containerFiles) {
   Write-Host "Adding file:" $file.FullName
   Set-AzureStorageBlobContent -Container $container -Blob $blob -File $file.FullName -Context $context
}
