# Monitoring



## Rules

* every running process should be started and stopped by common means (init, systemd, upstart, services)
* every running service must have working logging



## Baselines

monitoring should have a foundation in a baseline

* [baseline.sh](tools/linux/baseline.sh)
* [baseline.ps1](tools/windows/toolbox/baseline.ps1) (requires toolbox!)

### Linux full baseline
```
tar czf /tmp/$(hostname -f)-base.tgz --exclude='/aDirectory*' /bin /boot /etc /home /lib /lib64 /opt /root /sbin /usr /var [LOCALDIRS]
```
### Windows full baseline
warning: todo



## Processes, services, network activity, sessions and logs
[rosseta stone for unix](http://bhami.com/rosetta.html)
 <table>

<tr><td>Linux</td><td>
	`ps faxu`

	`ls -l /etc/init.d /etc/init`
	`systemctl`
	/etc/crontab, /etc/cron*, /var/spool/cron (anacron, at)

	`netstat -nlpaeo` (inode number might come handy when tracking malware persistence)
	`iptables-save`

	`w`

	/var/log, /var/adm
</td></tr>

<tr><td>bsd</td><td>
	`ps faxud`
</td></tr>

<tr><td>windows</td><td>
	`pslist /t`
	`wmic process get Caption,CommandLine,ProcessId,ExecutablePath`
	[pstree.ps1](tools/windows/toolbox/pstree.ps1)
	[fero.ps1](tools/windows/toolbox/fero.ps1)

	`sc.exe query|queryex`
	`wmic service list full`
	[services.ps1](tools/windows/toolbox/services.ps1)
	[autorunsc.bat](tools/windows/toolbox/autorunsc.bat)
	[scheduler-tasks.ps1](tools/windows/toolbox/scheduler-tasks.ps1)
	[scheduler-jobs.ps1](tools/windows/toolbox/scheduler-jobs.ps1)

	`netstat -ano`
	[firewall-rules.ps1](tools/windows/toolbox/firewall-rules.ps1)

	`query session`
	`reset session NUMBER`
	`net session`
	`netstat -n | findstr /C:":3389" | findstr ESTA`

	[eventlog-users.ps1](tools/windows/toolbox/eventlog-users.ps1)
	[eventlog-logon.ps1](tools/windows/toolbox/eventlog-logon.ps1)
	[eventlog-groups.ps1](tools/windows/toolbox/eventlog-groups.ps1)
	[eventlog-services.ps1](tools/windows/toolbox/eventlog-services.ps1)
	[eventlog-sheduler.ps1](tools/windows/toolbox/eventlog-scheduler.ps1)
	[eventlog-processcreation.ps1](tools/windows/toolbox/eventlog-processcreation.ps1) (auditing must be enabled)
</td></tr>

 </table>



## php engine request logger
* hook with `php_value auto_prepend_file "log-request.php"`
* `/data` must exist and be 777
* could be used as simple WAF

```
<?php
$unique = md5(uniqid());
$data =  json_encode($_SERVER, JSON_PRETTY_PRINT) . "\n";
$data .= json_encode($_POST, JSON_PRETTY_PRINT) . "\n";
$data .= json_encode($_GET, JSON_PRETTY_PRINT) . "\n";
file_put_contents( "/data/$unique", $data);
?>
```
