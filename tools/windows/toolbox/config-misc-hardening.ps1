# misc security configurations

## start notification/action center
Start-Service -Name wscsvc
Set-Service -Name wscsvc -StartupType Automatic
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name HideSCAHealth -Value 0x0 -Force


## enable uac (requires reboot to take effect)
Set-ItemProperty -Path HKLM:Software\Microsoft\Windows\CurrentVersion\policies\system -Name EnableLUA -Value 0x00000001 -Force


## don't install elevated
New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer
Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer -Name AlwaysInstallElevated -Value 0x00000000 -Force


## disable plaintext password caching; requires specific update to be installed; not successfully tested
#reg add HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest /v UseLogonCredential /t REG_DWORD /d 0x0 /f
## disable domain password caching
#reg add HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v DisableDomainCreds /t REG_DWORD /d 0x1 /f


## disable local administrator remote logon; disables remote psexec
# reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 0x0 /f
