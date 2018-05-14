# audit scheduler events


# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$OriginalBufferSize = $host.UI.RawUI.BufferSize; $NewBufferSize = $OriginalBufferSize; $NewBufferSize.width = 8192; $host.UI.RawUI.BufferSize = $NewBufferSize
}



$events = Get-WinEvent -FilterHashtable @{LogName="Microsoft-Windows-TaskScheduler/Operational"} -Oldest
if (!$events) { $events = @() }

foreach ($event in $events) {
	$event_xml = [xml]$event.ToXml()
	foreach ($tmp in $event_xml.Event.EventData.Data.GetEnumerator()) {
		Add-Member -InputObject $event -MemberType NoteProperty -Force -Name $tmp.name -Value $tmp."#text"
	}
}

$events | select @{n="TimeCreated";e={$_.TimeCreated.ToString("u")}}, Message | ConvertTo-Csv



# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$host.UI.RawUI.BufferSize = $OriginalBufferSize
}
