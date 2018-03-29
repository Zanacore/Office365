#Must run "Install-Module -Name MSOnline" On the computer before this will work
Clear-Host
$UserName = "Jason@zanacore.com"
$Cred = get-credential -Credential $UserName
Connect-MSOLService -Credential $Cred
Import-Module MSOnline
 
$clients = Get-MsolPartnerContract -All
 
$msolAccountSkuResults = @()
$msolAccountSkuCsv = "C:\temppath\LicenseList.csv"
 
ForEach ($client in $clients) {
 
$licenses = Get-MsolAccountSku -TenantId $client.TenantId
 
foreach ($license in $licenses){
 
$UnusedUnits = $license.ActiveUnits - $license.ConsumedUnits
 
$licenseProperties = @{
TenantId = $client.TenantID
CompanyName = $client.Name
PrimaryDomain = $client.DefaultDomainName
AccountSkuId = $license.AccountSkuId
AccountName = $license.AccountName
SkuPartNumber = $license.SkuPartNumber
ActiveUnits = $license.ActiveUnits
WarningUnits = $license.WarningUnits
ConsumedUnits = $license.ConsumedUnits
UnusedUnits = $unusedUnits
}
 
Write-Host "$($License.AccountSkuId) for $($Client.Name) has $unusedUnits unused licenses"
$msolAccountSkuResults += New-Object psobject -Property $licenseProperties
}
 
}
 
$msolAccountSkuResults | Select-Object TenantId,CompanyName,PrimaryDomain,AccountSkuId,AccountName,SkuPartNumber,ActiveUnits,WarningUnits,ConsumedUnits,UnusedUnits | Export-Csv -notypeinformation -Path $msolAccountSkuCsv
 
Write-Host "Script complete"