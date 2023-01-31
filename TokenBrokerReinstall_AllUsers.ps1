#Close all office applications
#Delete all credential manager entries for office 365
cmdkey /list | ForEach-Object{if($_ -like "*Target:*" -and $_ -like "*microsoft*"){cmdkey /del:($_ -replace " ","" -replace "Target:","")}}

#delete the identity key
reg delete HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Common\Identity /f

#delete broker plugin for all users
$users = Get-ChildItem C:\Users
foreach ($user in $users){$folder = "$($user.fullname)\AppData\Local\Packages\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy" 
#delete the broker plugin for all users
If (Test-Path $folder) {Remove-Item $folder -Recurse -Force -ErrorAction silentlycontinue } }

#Re-Install broker plugin
Add-AppxPackage -Register "C:\Windows\SystemApps\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy\Appxmanifest.xml" -DisableDevelopmentMode -ForceApplicationShutdown 

#Do no run dsregcmd /leave unless you have the ability to rejoin back to Azure AD
#DSRegCMD /ForceRecovery

write-host Please open Word.exe after completing the script
