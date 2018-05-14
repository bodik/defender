"==query"
reg.exe query "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v SMB1


"==setup"
# breaks winexe
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v SMB1 /t REG_DWORD /d 0x0 /f
