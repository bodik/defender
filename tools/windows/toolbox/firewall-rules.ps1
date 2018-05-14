# export active firewall rules


# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$OriginalBufferSize = $host.UI.RawUI.BufferSize; $NewBufferSize = $OriginalBufferSize; $NewBufferSize.width = 8192; $host.UI.RawUI.BufferSize = $NewBufferSize
}



(New-object -ComObject HNetCfg.FWPolicy2).rules |
	Where-Object {$_.enabled} |
	Sort-Object -Property direction |
	select Name,
		Description,
		ApplicationName,
		ServiceName,
		Protocol,
		LocalPorts,
		RemotePorts,
		LocalAddresses,
		RemoteAddresses,
		ICMPType,
		Direction,
		Action |
	ConvertTo-Csv



# windows 7 powershell output width
if ($PSVersionTable.PSVersion -lt "3.0") {
	$host.UI.RawUI.BufferSize = $OriginalBufferSize
}
