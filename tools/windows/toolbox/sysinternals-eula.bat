@echo off
reg.exe ADD "HKCU\Software\Sysinternals" /v EulaAccepted /t REG_DWORD /d 1 /f
reg.exe ADD "HKU\.DEFAULT\Software\Sysinternals" /v EulaAccepted /t REG_DWORD /d 1 /f
