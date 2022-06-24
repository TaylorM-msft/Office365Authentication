#set date time for transcript file name
$starttime = get-date -f MMddyy-hhmmtt

Start-Transcript "c:\temp\$starttime.txt"

#stop token broker service
net stop tokenbroker

#set token broker status
$BrokerStatus =  (get-service tokenbroker).status

#get currently logged in user, This does not work on a VM currently (working on this)
$LoggedinUser = ((Get-CimInstance -ClassName Win32_ComputerSystem).Username).Split('\')[1]

if ($BrokerStatus -ne "Running")
	{
		get-childItem -Path "c:\users\$loggedinuser\appdata\local\Packages\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy\AC\TokenBroker\Accounts" -include *.* -File -Recurse | foreach {$_.Delete()}
	}

else
	{
		net stop tokenbroker
		get-childItem -Path "c:\users\$loggedinuser\appdata\local\Packages\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy\AC\TokenBroker\Accounts" -include *.* -File -Recurse | foreach {$_.Delete()}
	}
	
#Set path for Settings.dat file in token broker plugin folder
$Settings = "c:\users\$loggedinuser\appdata\local\Packages\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy\Settings\settings.dat"
If (Test-Path $Settings)
	{
		$datetime = get-date -f MMddyy-hhmmtt
		Rename-Item -Path "c:\users\$loggedinuser\appdata\local\Packages\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy\Settings\settings.dat" -NewName ("Settings_" + $datetime + ".dat.old")
	}

#Set path to default account registry key, to enable checking if exists
$Registry = "HKEY_CURRENT_USER\Software\Microsoft\IdentityCRL\TokenBroker\DefaultAccount"
If (Test-Path $Registry)
	{
		reg export hkcu\software\microsoft\identitycrl\tokenbroker\DefaultAccount c:\temp\DefaultAccount.reg /y
		remove-item -Path "hkcu:\software\microsoft\identitycrl\tokenbroker\DefaultAccount" -recurse
	}
#start Token broker service
net start tokenbroker
#completion
write-host "complete: Please see c:\temp\$starttime.txt"
#stop transcript
stop-transcript
