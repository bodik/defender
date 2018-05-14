"==query"
reg.exe query "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v RestrictAnonymous
reg.exe query "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v RestrictAnonymousSAM
reg.exe query "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v NullSessionPipes
reg.exe query "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v NullSessionShares

"==setup"
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v RestrictAnonymous /t REG_DWORD /d 0x1 /f 
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v RestrictAnonymousSAM /t REG_DWORD /d 0x1 /f 
reg.exe add "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v NullSessionPipes /t REG_MULTI_SZ /d \0 /f
reg.exe add "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v NullSessionShares /t REG_MULTI_SZ /d \0 /f
