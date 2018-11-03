$prefix = "prefix"
$storageAccountName = $prefix + "storage"
$subscriptionName = "subname"
$slot = "Production"

Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"
Import-AzurePublishSettingsFile "C:\path\to\file.publishsettings"
Set-AzureSubscription -CurrentStorageAccountName $storageAccountName -SubscriptionName $subscriptionName -Verbose
$VerbosePreference = "Continue"
$cloudServices = @("cs1", "cs2", "cs3", "cs4")
foreach ($service in $cloudServices) {
   Write-Host "====================" $service "===================="
   $serviceName = $prefix + "-" + $service
   Write-Host "Removing" $serviceName"..."
   Remove-AzureService -ServiceName $serviceName -Force
   Write-Host "done"
}

$cloudWebsites = @("webapp1")
foreach ($site in $cloudWebsites) {
   Write-Host "====================" $site "===================="
   $name = $prefix + "-" + $site
   Write-Host "Removing" $name"..."
   Remove-AzureWebsite -Name $name -Force
   Write-Host "done"
}

Remove-AzureStorageAccount -StorageAccountName $storageAccountName
