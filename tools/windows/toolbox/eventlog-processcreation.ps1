# audit process creation eventlog


# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$OriginalBufferSize = $host.UI.RawUI.BufferSize; $NewBufferSize = $OriginalBufferSize; $NewBufferSize.width = 8192; $host.UI.RawUI.BufferSize = $NewBufferSize
}



$events = Get-WinEvent -FilterHashtable @{LogName="Security"; ID=4688} -Oldest
if (!$events) { $events = @() }

foreach ($event in $events) {
	$event_xml = [xml]$event.ToXml()
	foreach ($tmp in $event_xml.Event.EventData.Data.GetEnumerator()) {
		Add-Member -InputObject $event -MemberType NoteProperty -Force -Name $tmp.name -Value $tmp."#text"
	}

	Add-Member -InputObject $event -MemberType NoteProperty -Force -Name MessageFirstLine -Value ($event.Message -split "\n")[0].trim()

	try {
		$sid_object = New-Object System.Security.Principal.SecurityIdentifier($event.SubjectUserSid)
	   	$translated_subjectusersid = $sid_object.Translate([System.Security.Principal.NTAccount]).value
	} catch {
		$translated_subjectusersid = "not_translated"
	}
	Add-Member -InputObject $event -MemberType NoteProperty -Force -Name TranslatedSubjectUserSid -Value $translated_subjectusersid
}

$events | 
	select @{n="TimeCreated";e={$_.TimeCreated.ToString("u")}},
		MessageFirstLine,
		ParentProcessName,
		@{n="Username";e={$_.TranslatedSubjectUserSid}},
		NewProcessId,
		NewProcessName,
		CommandLine |
	ConvertTo-Csv



# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$host.UI.RawUI.BufferSize = $OriginalBufferSize
}
