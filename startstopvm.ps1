$ErrorActionPreference = "Stop"


$rg = "resource_group"
$vm = "vn_name"

$vmObj = Get-AzureRmVM -ResourceGroupName $rg -Name $vm
$vmObj.ProvisioningState

$startResponse = Start-AzureRmVM -ResourceGroupName $rg -Name $vm
if ($startResponse.IsSuccessStatusCode) {
  Write-Host "$vm started successfully"
}
else {
  Write-Host "$vm did not start"
  Write-Host $res.ReasonPhrase
}

$stopResponse = Stop-AzureRmVM -ResourceGroupName $rg -Name $vm -Force
if ($stopResponse.IsSuccessStatusCode) {
  Write-Host "$vm stopped successfully"
}
else {
  Write-Host "$vm did not stop"
  Write-Host $stopResponse.ReasonPhrase
}

$vmObj = Get-AzureRmVM -ResourceGroupName $rg -Name $vm
$vmObj.ProvisioningState
