# baseline


# setup
$env:PATH = "$env:PATH"+";"+(Split-Path -parent $MyInvocation.MyCommand.Definition)
mkdir -Force c:\windows\temp\baseline | Out-Null
Push-Location c:\windows\temp\baseline
(Get-Date).toString('u') > date.txt

## TODO: rewrite .reg to full .bat
sysinternals-eula.bat


# runtime
Get-Item Env: > environment.txt
hostname > hostname.txt
systeminfo > systeminfo.txt
tasklist /svc > tasklist.txt
pstree.ps1 > pstree.txt
Get-WMIObject win32_logicaldisk > disks.txt
query user > query-user.txt
fero.ps1 > fero.txt


### user account
wmic useraccount list brief > wmic-useraccount.txt
wmic group list brief > wmic-group.txt
net localgroup administrators > localgroup-administrators.txt
net localgroup "Remote Desktop Users" > localgroup-rdp.txt
if (Get-Command Get-LocalGroup -errorAction SilentlyContinue) {
	Get-LocalGroup | foreach { Write-Output("== '{0}' {1}" -f $_.Name, $_.SID.value); $_ | Get-LocalGroupMember | convertto-csv } > localgroup-members.txt
}


# config
dir "c:\" > programfiles.txt
dir "c:\Program Files" >> programfiles.txt
dir "c:\Program Files (x86)" >> programfiles.txt
Get-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*' | select DisplayName, DisplayVersion, Publisher, InstallDate >> programfiles.txt
autorunsc.bat > autorunsc.txt
wmic service list full > services-wmic.txt
services.ps1 > services-csv.txt
schtasks /query /xml > scheduler-xml.txt
scheduler-tasks.ps1 > scheduler-tasks.txt
scheduler-jobs.ps1 > scheduler-jobs.txt


# networking
ipconfig /all > ipconfig.txt
netsh interface ipv4 show neighbors > ipneighbors.txt
netsh interface ipv6 show neighbors >> ipneighbors.txt
firewall-rules.ps1 > firewall-rules.txt
netstat -ano > netstat.txt
route print > route.txt
net share > net-share.txt
net session > net-session.txt


# eventlogs
eventlog-groups.ps1 > eventlog-groups.txt
eventlog-users.ps1 > eventlog-users.txt
eventlog-logon.ps1 > eventlog-logon.txt
eventlog-services.ps1 > eventlog-services.txt
eventlog-scheduler.ps1 > eventlog-scheduler.txt
eventlog-processcreation.ps1 > eventlog-processcreation.txt


# convert all output files from utf16
Get-ChildItem | where { !$_.PSIsContainer } | foreach { $text = Get-Content $_; $text | Set-Content $_ -Encoding utf8 }
Pop-Location
