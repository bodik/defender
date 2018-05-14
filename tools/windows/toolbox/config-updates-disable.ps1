"==query"
reg.exe query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /s
sc.exe qc wuauserv
sc.exe queryex wuauserv


"==setup"
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "AUOptions" /t REG_DWORD /d 0x1 /f
sc.exe stop wuauserv
sc.exe config wuauserv start= disabled
