$prefix = "dml"
$storageAccountName = $prefix + "storage"
$slot = "Production"

Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"
Import-AzurePublishSettingsFile "C:\path\to\file.publishsettings"
$VerbosePreference = "Continue"
$cloudServices = @("cs1", "cs2", "cs3", "cs4")
foreach ($service in $cloudServices) {
   Write-Host "====================" $service "===================="
   $serviceName = $prefix + "-" + $service
   Write-Host "Stopping" $serviceName"..."
   Stop-AzureService -ServiceName $serviceName -Slot $slot
   Write-Host "done"
}

$cloudWebsites = @("webapp1")
foreach ($site in $cloudWebsites) {
   Write-Host "====================" $site "===================="
   $name = $prefix + "-" + $site
   Write-Host "Stopping" $name"..."
   Stop-AzureWebsite -Name $name
   Write-Host "done"
}
