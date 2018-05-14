# show scheduler jobs


# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$OriginalBufferSize = $host.UI.RawUI.BufferSize; $NewBufferSize = $OriginalBufferSize; $NewBufferSize.width = 8192; $host.UI.RawUI.BufferSize = $NewBufferSize
}



# setup test job
#Register-ScheduledJob -Name testGPS -Trigger (New-JobTrigger -Daily -At 11:11) -ScriptBlock {GPS}
#Receive-Job -Id 4 -Keep

if (Get-Command Get-ScheduledJob -errorAction SilentlyContinue) {
	$scheduled_jobs = Get-ScheduledJob
} else {
	$scheduled_jobs = @()
}

$scheduled_jobs |
	select Id,
		Name,
		Enabled,
		@{n="JobTriggers.At";e={$_.JobTriggers | where { $_.Enabled} | foreach { $_.At.ToString("u"), $_.DaysOfWeek, $_.Frequency, $_.Interval} }},
		Command,
		Credential,
		PSExecutionPath,
		PSExecutionArgs |
	ConvertTo-Csv



# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$host.UI.RawUI.BufferSize = $OriginalBufferSize
}
