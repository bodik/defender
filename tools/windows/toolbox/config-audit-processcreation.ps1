"==query"	
AuditPol /get /category:"Detailed Tracking"


"==setup"
AuditPol /set /category:"Detailed Tracking" /success:enable
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit" /v "ProcessCreationIncludeCmdLine_Enabled" /t REG_DWORD /d 0x1 /f
