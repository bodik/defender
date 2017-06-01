# Windows Baselining

## check used binaries
```
date /t & time /t
set | findstr /i path
```



## basic info
```
hostname
systeminfo
```



## networking
```
ipconfig /all
netsh interface ipv4 show neighbors
netsh interface ipv6 show neighbors
route -4 print
route -6 print
netsh advfirewall firewall show rule name=all
```



## runtime info
```
tasklist /svc
pslist /t
ferox32.exe -c -m
ferox64.exe -c -m
wmic service list full
query user
net sessions
```



## users
```
net user
net localgroup Administrators
net localgroup "Remote Desktop"
wmic useraccount list brief
wmic group list brief
```



## software
```
dir "c:\Program Files"
dir "c:\Program Files (x86)"
powershell "Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate"
powershell ./nishang-Get-Information.ps1
```
[nishang-Get-Information.ps1](../tools/nishang-Get-Information.ps1)

## filesystem
<span style="color:red">TODO</span>
