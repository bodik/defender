# fero powershell+sysinternals implementation

$env:PATH = "$env:PATH"+";"+(Split-Path -parent $MyInvocation.MyCommand.Definition)
if ($env:PROCESSOR_ARCHITECTURE -eq "x86") { $handle_bin = "handle.exe" } else { $handle_bin = "handle64.exe" }


$netstats = @{}
$netstat = netstat -ano | select -skip 4
foreach ($line in $netstat) {
	$tmppid = [int]($line -split "\s+")[-1]
	if (!$netstats.ContainsKey($tmppid)) {
		$netstats[$tmppid] = @()
	}
	$netstats[$tmppid] = $netstats[$tmppid] + $line
}

$processes = Get-WMIObject -Class Win32_Process
foreach ($process in $processes) {
	if ($Process.CommandLine) {
		$description = $Process.CommandLine
	} else {
		$description = $Process.Caption
	}
	try {
		$process_user = $process.getowner().user
	} catch {
		$process_user = "unknown"
	}

	Write-Output ("=== pid:{0} ppid:{1} owner:{2} caption:{3} desc:{4}" -f $process.ProcessId, $process.ParentProcessId, $process_user, $process.Caption, $description)

	& $handle_bin -a -u -p $process.ProcessId | findstr /C:": File" | foreach { "file: {0}" -f $_ }

	if ($netstats.ContainsKey([int]$process.ProcessId)) {
		$netstats[[int]$process.ProcessId] | foreach { "net: {0}" -f $_ }
	}
	
	Write-Output ""
}
