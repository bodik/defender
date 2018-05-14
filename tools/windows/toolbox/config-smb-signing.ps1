"==query"
reg.exe query "HKLM\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" /v enablesecuritysignature


"==setup"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters" /v enablesecuritysignature /t REG_DWORD /d 0x1 /f
