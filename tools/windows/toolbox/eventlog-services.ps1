# audit security events on services management
#
# 7030 The <service name> service is marked as an interactive service. However, the system is configured to not allow interactive services. This service may not function properly.
# ?? 7040 The start type of the <service> service was changed from disabled to auto start
# 7045 A service was installed in the system.


# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$OriginalBufferSize = $host.UI.RawUI.BufferSize; $NewBufferSize = $OriginalBufferSize; $NewBufferSize.width = 8192; $host.UI.RawUI.BufferSize = $NewBufferSize
}



$events = Get-WinEvent -FilterHashtable @{LogName="System"; ID=7030,7045} -Oldest
if (!$events) { $events = @() }

foreach ($event in $events) {
	$event_xml = [xml]$event.ToXml()
	foreach ($tmp in $event_xml.Event.EventData.Data.GetEnumerator()) {
		Add-Member -InputObject $event -MemberType NoteProperty -Force -Name $tmp.name -Value $tmp."#text"
	}

	Add-Member -InputObject $event -MemberType NoteProperty -Force -Name MessageFirstLine -Value ($event.Message -split "\n")[0].trim()
}

$events | select @{n="TimeCreated";e={$_.TimeCreated.ToString("u")}}, LevelDisplayName, MessageFirstLine, ServiceName, ServiceType, ImagePath | ConvertTo-Csv



# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$host.UI.RawUI.BufferSize = $OriginalBufferSize
}
