Param(
  [string]$dropSitePath,
  [string]$workspace
)

$ErrorActionPreference = "Stop"

Write-Host "dropSitePath:" $dropSitePath
Write-Host "workspace:" $workspace

$dropSite = "\\path\to\" + $dropSitePath
$folder = $workspace + "\folder\" 

New-Item -ItemType directory -Path $dropSite -Force
Copy-Item $folder -Destination $dropSite -recurse -Force
