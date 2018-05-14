# audit events on user accounts
#
# 4720 A user account was created.
# 4722 A user account was enabled.
# 4725 A user account was disabled.
# 4726 A user account was deleted.
# 4740 A user account was locked out.
# 4767 A user account was unlocked.


# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$OriginalBufferSize = $host.UI.RawUI.BufferSize; $NewBufferSize = $OriginalBufferSize; $NewBufferSize.width = 8192; $host.UI.RawUI.BufferSize = $NewBufferSize
}



$events = Get-WinEvent -FilterHashtable @{LogName="Security"; ID=4720,4722,4725,4726,4740,4767} -Oldest
if (!$events) { $events = @() }

foreach ($event in $events) {
	$event_xml = [xml]$event.ToXml()
	foreach ($tmp in $event_xml.Event.EventData.Data.GetEnumerator()) {
		Add-Member -InputObject $event -MemberType NoteProperty -Force -Name $tmp.name -Value $tmp."#text"
	}
	
	Add-Member -InputObject $event -MemberType NoteProperty -Force -Name MessageFirstLine -Value ($event.Message -split "\n")[0].trim()
}

$events | select @{n="TimeCreated";e={$_.TimeCreated.ToString("u")}}, MessageFirstLine, @{n="Username";e={"$($_.TargetDomainName)\$($_.TargetUserName)"}}, TargetSid | ConvertTo-Csv



# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$host.UI.RawUI.BufferSize = $OriginalBufferSize
}
