# powershell pstree inspired by internet the point is to have tree including pid, ppid, username, cmdline


# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$OriginalBufferSize = $host.UI.RawUI.BufferSize; $NewBufferSize = $OriginalBufferSize; $NewBufferSize.width = 8192; $host.UI.RawUI.BufferSize = $NewBufferSize
}



function Show-ProcessTree($Process, $IndentLevel) {
	$Indent = " " * $IndentLevel
	if ($Process.CommandLine) {
		$Description = $Process.CommandLine
	} else {
		$Description = $Process.Caption
	}
	Write-Output ("{0,6} {1,6} {2,20} {3,30} {4} {5}" -f $Process.ProcessId, $Process.ParentProcessId, $Process.getowner().user, $Process.Caption, $Indent, $Description)

	foreach ($Child in ($ProcessByParent[$Process.ProcessId] | Sort-Object CreationDate)) {
		Show-ProcessTree $Child ($IndentLevel + 4)
	}
}

$ProcessWithoutParent = @()
$ProcessById = @{}
$ProcessByParent = @{}

foreach ($Process in (Get-WMIObject -Class Win32_Process)) {
	$ProcessById[$Process.ProcessId] = $Process
}

foreach ($Process in $ProcessById.values) {
	if (($Process.ParentProcessId -eq 0) -or !$ProcessById.ContainsKey($Process.ParentProcessId)) {
		$ProcessWithoutParent += $Process
		continue
	}

	if (!$ProcessByParent.ContainsKey($Process.ParentProcessId)) {
		$ProcessByParent[$Process.ParentProcessId] = @()
	}
	$ProcessByParent[$Process.ParentProcessId] = $ProcessByParent[$Process.ParentProcessId] + $Process
}

foreach ($Process in ($ProcessWithoutParent | Sort-Object ParentProcessId, ProcessId)) {
	Show-ProcessTree $Process 0
}



# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$host.UI.RawUI.BufferSize = $OriginalBufferSize
}
