Param(
  [string]$service,
  [string]$subscriptionName,
  [string]$workspace
)

$ErrorActionPreference = "Stop"

Write-Host "service:" $service
Write-Host "subscriptionName:" $subscriptionName
Write-Host "workspace:" $workspace

$prefix = "prefix"
$serviceName = $prefix + "-" + $subscriptionName + "-" + $service
$azurePublishSettingsFile = "c:\pathto\credentials.publishsettings"
$storageAccountName = "storage" + $subscriptionName.ToLower()
Write-Host "storageAccountName:" $storageAccountName
$slot = "Staging"
$package = $workspace + "\Service.Name." + $service + ".cspkg"
$configuration = $workspace + "\ServiceConfiguration.Test.cscfg"

Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"
Import-AzurePublishSettingsFile $azurePublishSettingsFile

$VerbosePreference = "Continue"

Set-AzureSubscription -CurrentStorageAccountName $storageAccountName -SubscriptionName $subscriptionName

$deployment = Get-AzureDeployment -ServiceName $serviceName -Slot $slot -ErrorAction SilentlyContinue -ErrorVariable error
if (!$error[0]) {
   Write-Host "==================== Removing Staging deployment for $serviceName ===================="  
   Remove-AzureDeployment -ServiceName $serviceName -Slot Staging -Force
}

New-AzureDeployment -Configuration $configuration -Package $package -ServiceName $serviceName -Slot $slot

$allInstancesReady = $FALSE

while (!$allInstancesReady) {
   Write-Host "==================== Checking status of Instances ===================="
   Start-Sleep -s 30
   $deployment = Get-AzureDeployment -ServiceName $serviceName -Slot $slot
   $numberOfInstances = $deployment.RoleInstanceList.Count
   $readyInstances = 0
   
   foreach ($instance in $deployment.RoleInstanceList) {
      $name = $instance.InstanceName
      $status = $instance.InstanceStatus
      Write-Host $name "-" $status
      
      if ($status -eq "ReadyRole") {
         $readyInstances++
      }
     
      if ($numberOfInstances -eq $readyInstances) { 
         $allInstancesReady = $TRUE
      }
   }
}

Write-Host "==================== All Instances are Ready ===================="

cd $workspace
$deployment = Get-AzureDeployment -slot $slot -serviceName $servicename
$deploymentUrl = $deployment.Url
"DEPLOYMENTURL=" + $deploymentUrl.AbsoluteUri.Replace('http','https') | Out-File -encoding ascii Deployment.properties
Write-Host "Created Cloud Service with URL $deploymentUrl."