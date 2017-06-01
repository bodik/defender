# Monitoring

## Rules

* every running process should be started and stopped by common means
	* init, systemd, upstart
	* services

* every running service must have working logging

## Processes
```
# Linux
ps faxu

# FreeBSD
ps faxud

# windows
pslist /t
wmic process get Caption,CommandLine,ProcessId,ExecutablePath 
```


## Services
```
# Linux
ls -l /etc/init.d /etc/init
systemctl

# Windows
wmic service list full
```

## Networking
```
# Linux
netstat -nlpaeo

# Windows
netstat -an
```

## Sessions
```
# Linux
w

# Windows
query session
reset session NUMBER
net session
netstat -n | find ":3389" | find "ESTABLISHED"
```

## php engine request logger
```
cat << __EOF__ > /etc/apache2/log-request.php
<?php
\$unique = md5(uniqid());
\$data =  json_encode(\$_SERVER, JSON_PRETTY_PRINT) . "\n";
\$data .= json_encode(\$_POST, JSON_PRETTY_PRINT) . "\n";
\$data .= json_encode(\$_GET, JSON_PRETTY_PRINT) . "\n";
file_put_contents( "/data/\$unique", \$data);
?>
__EOF__

<VirtualHost *:80>
php_value auto_prepend_file "/etc/apache2/log-request.php"
</VirtualHost>
```
