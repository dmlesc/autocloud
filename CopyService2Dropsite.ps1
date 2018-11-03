Param(
  [string]$service,
  [string]$dropSitePath,
  [string]$workspace
)

$ErrorActionPreference = "Stop"

$dropSite = "\\path\to\" + $dropSitePath
$package = $workspace + "\bin\Service.Name." + $service + ".cspkg"
$configuration = $workspace + "\bin\ServiceConfiguration.Test.cscfg"

Write-Host "service:" $service
Write-Host "dropSite:" $dropSite
Write-Host "package:" $package
Write-Host "configuration:" $configuration

New-Item -ItemType directory -Path $dropSite -Force

$serviceFiles = $workspace + "\bin\"
Copy-Item $serviceFiles -Destination $dropSite -recurse
