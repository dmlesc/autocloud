Param(
  [string]$webapp,
  [string]$dropSitePath,
  [string]$workspace
)

$ErrorActionPreference = "Stop"

Write-Host "webapp:" $webapp
Write-Host "dropSitePath:" $dropSitePath
Write-Host "workspace:" $workspace

$dropSite = "\\path\to\" + $dropSitePath
#$webappFiles = $workspace + "\bin\"
$webappZip = $workspace + "\" + $webapp + ".zip"


New-Item -ItemType directory -Path $dropSite -Force
#Copy-Item $webappFiles -Destination $dropSite -recurse
Copy-Item $webappZip -Destination $dropSite
