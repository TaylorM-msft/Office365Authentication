$users = Get-ChildItem C:\Users
#Delete all credential manager entries for office 365
cmdkey /list | ForEach-Object{if($_ -like "*Target:*" -and $_ -like "*microsoft*"){cmdkey /del:($_ -replace " ","" -replace "Target:","")}}
#Delete all credential manager entries for TEAMs
cmdkey /list | ForEach-Object{if($_ -like "*Target:*" -and $_ -like "*msteams*"){cmdkey /del:($_ -replace " ","" -replace "Target:","")}}

#Delete Identity Registry key
reg delete HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\Common\Identity /f
reg delete HKEY_CURRENT_USER\SOFTWARE\Microsoft\IdentityCRL /f
reg delete HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\AAD /f
reg delete HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WorkplaceJoin /f

foreach ($user in $users)
{	#Delete all Teams cache
	$folder0 = "$($user.fullname)\AppData\Roaming\Microsoft\teams\application cache\cache\"
	$folder1 = "$($user.fullname)\AppData\Roaming\Microsoft\teams\blob_storage\"
	$folder2 = "$($user.fullname)\AppData\Roaming\Microsoft\teams\databases\"
	$folder3 = "$($user.fullname)\AppData\Roaming\Microsoft\teams\GPUcache\"
	$folder4 = "$($user.fullname)\AppData\Roaming\Microsoft\teams\IndexedDB\"
	$folder5 = "$($user.fullname)\AppData\Roaming\Microsoft\teams\Local Storage\"
	$folder6 = "$($user.fullname)\AppData\Roaming\Microsoft\teams\tmp\"
	$folder7 = "$($user.fullname)\AppData\Local\Microsoft\TokenBroker\Cache\"
	$folder8 = "$($user.fullname)\AppData\Local\Packages\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy"
	If (Test-Path $folder0) {Remove-Item $folder0 -Recurse -Force -ErrorAction silentlycontinue }
	If (Test-Path $folder1) {Remove-Item $folder1 -Recurse -Force -ErrorAction silentlycontinue }
	If (Test-Path $folder2) {Remove-Item $folder2 -Recurse -Force -ErrorAction silentlycontinue }
	If (Test-Path $folder3) {Remove-Item $folder3 -Recurse -Force -ErrorAction silentlycontinue }
	If (Test-Path $folder4) {Remove-Item $folder4 -Recurse -Force -ErrorAction silentlycontinue }
	If (Test-Path $folder5) {Remove-Item $folder5 -Recurse -Force -ErrorAction silentlycontinue }
	If (Test-Path $folder6) {Remove-Item $folder6 -Recurse -Force -ErrorAction silentlycontinue }
	If (Test-Path $folder7) {Remove-Item $folder7 -Recurse -Force -ErrorAction silentlycontinue }
	If (Test-Path $folder8) {Remove-Item $folder8 -Recurse -Force -ErrorAction silentlycontinue }
}
Add-AppxPackage -Register "C:\Windows\SystemApps\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy\Appxmanifest.xml" -DisableDevelopmentMode -ForceApplicationShutdown 
