"==query"
reg.exe query "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LMCompatibilityLevel


"==setup"
# Send NTLMv2 response only. Refuse LM & NTLM.
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v LMCompatibilityLevel /t REG_DWORD /d 0x5 /f
