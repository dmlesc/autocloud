Param(
  [string]$webapp,
  [string]$subscriptionName
)

$ErrorActionPreference = "Stop"

Write-Host "webapp:" $webapp
Write-Host "subscriptionName:" $subscriptionName

$prefix = "prefix"
$name = $prefix + "-" + $subscriptionName + "-" + $webapp
$azurePublishSettingsFile = "c:\pathto\credentials.publishsettings"
$storageAccountName = "storage"

Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"
Import-AzurePublishSettingsFile $azurePublishSettingsFile

$VerbosePreference = "Continue"

Set-AzureSubscription -CurrentStorageAccountName $storageAccountName -SubscriptionName $subscriptionName

Switch-AzureWebsiteSlot -Name $name -Force -Verbose