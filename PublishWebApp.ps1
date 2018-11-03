Param(
  [string]$webapp,
  [string]$subscriptionName,
  [string]$workspace
)

$ErrorActionPreference = "Stop"

Write-Host "webapp:" $webapp
Write-Host "subscriptionName:" $subscriptionName
Write-Host "workspace:" $workspace

$prefix = "prefix"
$name = $prefix + "-" + $subscriptionName + "-" + $webapp
$package = $workspace + "\" + $webapp + ".zip" 
$slot = "Staging"
$azurePublishSettingsFile = "c:\pathto\credentials.publishsettings"
$storageAccountName = "storage"

Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"
Import-AzurePublishSettingsFile $azurePublishSettingsFile

$VerbosePreference = "Continue"

Set-AzureSubscription -CurrentStorageAccountName $storageAccountName -SubscriptionName $subscriptionName

Publish-AzureWebsiteProject -Package $package -Name $name -Slot $slot

