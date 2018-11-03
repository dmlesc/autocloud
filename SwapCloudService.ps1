Param(
  [string]$service,
  [string]$subscriptionName
)

$ErrorActionPreference = "Stop"

Write-Host "service:" $service
Write-Host "subscriptionName:" $subscriptionName

$prefix = "prefix"
$serviceName = $prefix + "-" + $subscriptionName + "-" + $service
$azurePublishSettingsFile = "c:\pathto\credentials.publishsettings"
$storageAccountName = "storage" + $subscriptionName.ToLower()
$slot = "Staging"

Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"
Import-AzurePublishSettingsFile $azurePublishSettingsFile

$VerbosePreference = "Continue"

Set-AzureSubscription -CurrentStorageAccountName $storageAccountName -SubscriptionName $subscriptionName
Move-AzureDeployment -ServiceName $serviceName
Remove-AzureDeployment -ServiceName $serviceName -Slot $slot -Force
