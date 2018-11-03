$prefix = "prefix"
$scriptPath = "C:\working\dir\scripts\azure\"
$azurePublishSettingsFile = $scriptPath + "file.publishsettings"
$location = "West US"
$storageAccountName = $prefix + "storage"
$subscriptionName = "subName"
$certToDeploy = $scriptPath + "your.cert.com.pfx"
$password = 'certpass'
$slot = "Production"

Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"
Import-AzurePublishSettingsFile $azurePublishSettingsFile
$VerbosePreference = "Continue"
$storageAccount = Get-AzureStorageAccount -StorageAccountName $storageAccountName -ErrorAction SilentlyContinue -ErrorVariable error
if ($error[0]) {
   Write-Host $storageAccountName "does not exist. Creating..."
   New-AzureStorageAccount -Location $location -StorageAccountName $storageAccountName -Type "Standard_LRS"
}
Set-AzureStorageAccount $storageAccountName
Set-AzureSubscription -CurrentStorageAccountName $storageAccountName -SubscriptionName $subscriptionName

$containersPath = $scriptPath + "containers"
$containers = Get-ChildItem $containersPath

foreach ($container in $containers) {
   Write-Host "Creating container" $container"..."
   New-AzureStorageContainer -Name $container
   $containerFilesPath = $containersPath + "\" + $container
   $containerFiles = Get-ChildItem $containerFilesPath
   $iml = $FALSE
   $blob = ""

   if (($containerFiles[0]) -is [System.IO.DirectoryInfo]) {
      $iml = $TRUE
      $build = $containerFiles[0].Name + "/"
      $containerFiles = Get-ChildItem $containerFiles[0].FullName
   }

   foreach ($file in $containerFiles) {
      Write-Host "Adding file:" $file.FullName
      if ($iml) {
         $blob = $build + $file.Name
      }
      Set-AzureStorageBlobContent -Container $container -Blob $blob -File $file.FullName
   }
}

$cloudServices = @("cs1", "cs2", "cs3", "cs4")
foreach ($service in $cloudServices) {
   Write-Host "====================" $service "===================="
   $path = $scriptPath + "packages\Service.Name." + $service
   $configuration = $path + "\ServiceConfiguration.Test.cscfg"
   $package = $path + "\Service.Name." + $service + ".cspkg"
   $serviceName = $prefix + "-" + $service
   $service = Get-AzureService -ServiceName $serviceName -ErrorAction SilentlyContinue -ErrorVariable error
   if ($error[0]) {
      Write-Host $serviceName "does not exist. Creating..."
      New-AzureService -Location $location -ServiceName $serviceName
      Add-AzureCertificate -CertToDeploy $certToDeploy -ServiceName $serviceName -Password $password
      New-AzureDeployment -Configuration $configuration -Package $package -ServiceName $serviceName -Slot $slot
   }
   else {
      Write-Host $serviceName "already exists. Upgrading..."
      Set-AzureDeployment -Configuration $configuration -Package $package -ServiceName $serviceName -Slot $slot -Upgrade -Force
   }
   Write-Host "done"
}

$cloudWebsites = @("webapp1")
foreach ($site in $cloudWebsites) {
   Write-Host "====================" $site "===================="
   $package = $scriptPath + "packages\" + $site
   $name = $prefix + "-" + $site
   $website = Get-AzureWebsite -Name $name
   if ($website.Name -eq $null) {
      Write-Host $site "does not exist. Creating..."
      New-AzureWebsite -Location $location -Name $name
   }
   else {
      Write-Host $site "already exists. Upgrading..."
   }
   Start-AzureWebsite -Name $name
   Publish-AzureWebsiteProject -Name $name -Package $package
   Write-Host "done"
}