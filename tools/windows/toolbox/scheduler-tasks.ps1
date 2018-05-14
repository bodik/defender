# show scheduler taks


# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$OriginalBufferSize = $host.UI.RawUI.BufferSize; $NewBufferSize = $OriginalBufferSize; $NewBufferSize.width = 8192; $host.UI.RawUI.BufferSize = $NewBufferSize
}



if (Get-Command Get-ScheduledTask -errorAction SilentlyContinue) {
	$scheduled_tasks = Get-ScheduledTask
} else {
	$scheduled_tasks = @()
}

$scheduled_tasks |
	select TaskName,
		TaskPath,
		State,
		@{n="Actions.execute";e={$_.Actions.execute}},
		@{n="Actions.arguments";e={$_.Actions.arguments}},
		@{n="LastRunTime";e={($_ | Get-ScheduledTaskInfo).LastRunTime.ToString("u")}},
		@{n="NextRunTime";e={($_ | Get-ScheduledTaskInfo).NextRunTime.ToString("u")}} |
	ConvertTo-Csv



# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$host.UI.RawUI.BufferSize = $OriginalBufferSize
}
