# audit security events on logon/logoff actions
#
# 4624: An account was successfully logged on
# 4625: An account failed to log on
# 4634: An account was logged off
# 4647: User initiated logoff
#
# 0 Used only by the System account.
# 2 Interactive (logon at keyboard and screen of system) Windows 2000 records Terminal Services logon as this type rather than Type 10.
# 3 Network (i.e. connection to shared folder on this computer from elsewhere on network or IIS logon - Never logged by 528 on W2k and forward. See event 540)
# 4 Batch (i.e. scheduled task)
# 5 Service (Service startup)
# 6 Proxy
# 7 Unlock (i.e. unnattended workstation with password protected screen saver)
# 8 NetworkCleartext (Logon with credentials sent in the clear text. Most often indicates a logon to IIS with "basic authentication") See this article for more information.
# 9 NewCredentials
# 10 RemoteInteractive (Terminal Services, Remote Desktop or Remote Assistance)
# 11 CachedInteractive (logon with cached domain credentials such as when logging on to a laptop when away from the network)
# 12 CachedRemoteInteractive Same as RemoteInteractive. This is used for internal auditing.
# 13 CachedUnlock Workstation logon.



# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$OriginalBufferSize = $host.UI.RawUI.BufferSize; $NewBufferSize = $OriginalBufferSize; $NewBufferSize.width = 8192; $host.UI.RawUI.BufferSize = $NewBufferSize
}



$message_short = @{4624="logon success"; 4625="logon failed"; 4634="logoff"; 4647="logoff user";}
$logon_type_text = @{
	"0"="system"; "2"="interactive"; "3"="network"; "4"="batch"; "5"="service"; "7"="unlock"; "8"="network cleartext";
	"9"="new credentials"; "10"="remote interactive"; "11"="cached interactive"; "12"="cached remote interactive"; "13"="cached unlock"
}
$filter_out = @("0", "5")

$events = Get-WinEvent -FilterHashtable @{LogName="Security"; ID=4624,4625,4634,4647} -Oldest
if (!$events) { $events = @() }

foreach ($event in $events) {
	$event_xml = [xml]$event.ToXml()
	foreach ($tmp in $event_xml.Event.EventData.Data.GetEnumerator()) {
		Add-Member -InputObject $event -MemberType NoteProperty -Force -Name $tmp.name -Value $tmp."#text"
	}

	Add-Member -InputObject $event -MemberType NoteProperty -Force -Name MessageShort -Value $message_short[$event.Id]

	try { $tmp = $logon_type_text[$event.LogonType] } catch { $tmp = "undefined" }
	Add-Member -InputObject $event -MemberType NoteProperty -Force -Name LogonTypeText -Value $tmp
}

$events |
	where { $filter_out -notcontains $_.LogonType } |
	select @{n="TimeCreated";e={$_.TimeCreated.ToString("u")}},
		MessageShort,
		LogonTypeText,
		@{n="Username";e={"$($_.TargetDomainName)\$($_.TargetUserName)"}},
		TargetUserSid,
		IpAddress,
		LogonProcessName,
		ProcessName |
	ConvertTo-Csv



# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$host.UI.RawUI.BufferSize = $OriginalBufferSize
}
