#Close all office applications
#Delete all credential manager entries for office 365
cmdkey /list | ForEach-Object{if($_ -like "*Target:*" -and $_ -like "*microsoft*"){cmdkey /del:($_ -replace " ","" -replace "Target:","")}}

#delete the identity key
reg delete HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Common\Identity /f

#Delete Default Account registry key
reg delete HKEY_CURRENT_USER\Software\Microsoft\IdentityCRL\TokenBroker\DefaultAccount /f

#delete broker plugin for all users
$users = Get-ChildItem C:\Users
foreach ($user in $users){
$folder0 = "$($user.fullname)\AppData\Local\Packages\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy"
$folder1 = "$($user.fullname)\AppData\Local\Microsoft\IdentityCache"
$folder2 = "$($user.fullname)\AppData\Local\Microsoft\OneAuth"

#delete the broker plugin for all users
If (Test-Path $folder0) {Remove-Item $folder0 -Recurse -Force -ErrorAction silentlycontinue}
If (Test-Path $folder1) {Remove-Item $folder1 -Recurse -Force -ErrorAction silentlycontinue}
If (Test-Path $folder2) {Remove-Item $folder2 -Recurse -Force -ErrorAction silentlycontinue}
}

#Re-Install broker plugin
Add-AppxPackage -Register "$env:windir\SystemApps\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy\Appxmanifest.xml" -DisableDevelopmentMode -ForceApplicationShutdown 

#Do not run dsregcmd /leave unless you have the ability to rejoin back to Azure AD
#Verify you have a local Account on the machine before running any /leave or /ForceRecovery commands as you may be required to login to re-join Azure AD without Line of sight to DC
#DSRegCMD /ForceRecovery

write-host Please open Word.exe after completing the script
