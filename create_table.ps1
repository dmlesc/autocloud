$scriptPath = "C:\azure\"
$azurePublishSettingsFile = $scriptPath + "TEST-credentials.publishsettings"
$storageAccountName = "name"
$subscriptionName = "TEST"

$table = "table"

Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"
Import-AzurePublishSettingsFile $azurePublishSettingsFile

$VerbosePreference = "Continue"

Set-AzureSubscription -CurrentStorageAccountName $storageAccountName -SubscriptionName $subscriptionName

Write-Host "Creating table $table..."

New-AzureStorageTable -Name $table