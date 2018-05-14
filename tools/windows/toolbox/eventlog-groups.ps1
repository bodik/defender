# audit security events on global, local and universal groups
#
# 4727 A security-enabled global group was created.
# 4728 A member was added to a security-enabled global group.
# 4729 A member was removed from a security-enabled global group.
# 4730 A security-enabled global group was deleted.
# 4731 A security-enabled local group was created.
# 4732 A member was added to a security-enabled local group.
# 4733 A member was removed from a security-enabled local group.
# 4734 A security-enabled local group was deleted.
# 4754 A security-enabled universal group was created.
# 4756 A member was added to a security-enabled universal group.
# 4757 A member was removed from a security-enabled universal group.
# 4758 A security-enabled universal group was deleted.


# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$OriginalBufferSize = $host.UI.RawUI.BufferSize; $NewBufferSize = $OriginalBufferSize; $NewBufferSize.width = 8192; $host.UI.RawUI.BufferSize = $NewBufferSize
}



$events = Get-WinEvent -FilterHashtable @{LogName="Security"; ID=4727,4728,4729,4730, 4731,4732,4733,4734, 4754,4756,4757,4758} -Oldest
if (!$events) { $events = @() }

foreach ($event in $events) {
	$event_xml = [xml]$event.ToXml()
	foreach ($tmp in $event_xml.Event.EventData.Data.GetEnumerator()) {
		Add-Member -InputObject $event -MemberType NoteProperty -Force -Name $tmp.name -Value $tmp."#text"
	}

	Add-Member -InputObject $event -MemberType NoteProperty -Force -Name MessageFirstLine -Value ($event.Message -split "\n")[0].trim()

	try {
		$sid_object = New-Object System.Security.Principal.SecurityIdentifier($event.MemberSid)
	   	$translated_membersid = $sid_object.Translate([System.Security.Principal.NTAccount]).value
	} catch {
		$translated_membersid = "not_translated"
	}
	Add-Member -InputObject $event -MemberType NoteProperty -Force -Name TranslatedMemberSid -Value $translated_membersid
}

$events |
	select @{n="TimeCreated";e={$_.TimeCreated.ToString("u")}},
		MessageFirstLine,
		@{n="Username";e={$_.TranslatedMemberSid}},
		@{n="UserSid";e={$_.MemberSid}},
		@{n="Groupname";e={$_.TargetUserName}},
		@{n="GroupSid";e={$_.TargetSid}} |
			ConvertTo-Csv



# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$host.UI.RawUI.BufferSize = $OriginalBufferSize
}
