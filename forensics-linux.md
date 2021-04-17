# Linux forensics

## generate timeline
```
Linux: find / -xdev -print0 | xargs -0 stat -c "%Y %X %Z %A %U %G %n" >> timestamps.dat
FreeBSD: find / -xdev -print0 | xargs -0 stat -f "%a %m %c %Sp %Su %Sg %N" >> timestamps.dat
timeline_decorator.py < timestamps.dat | sort -n > timeline.txt
```
[timeline_decorator.py](../tools/linux/timeline_decorator.py)



## check against package manager hashes
even if you know that you cann't fully trust them

### Debian
```
cd / && find /var/lib/dpkg/info/ -name "*md5sums" -exec md5sum -c {} \; | grep -v OK
debsums
```

### RedHat
```
rpm -Va
```

### FreeBSD
```
freebsd-update IDS
pkg check -s -a
```



## places to hide malware/backdoors/persistence
* kernel modules, initrd/initramdisk
* init files (/etc/inittab, /etc/init.d/, /etc/init/, /lib/systemd/system/, ...)
* preloaded libs (/etc/ld.so.*)
* rogue pam modules
* snmpd.conf allowing external command executions
* crontabs, atjobs
* rc files (~/.bashrc, ~/.bash_profile, ~/.profile, ...)
* additional files within web applications, .htaccess bind php to any mimetime/filename
* files containing spaces ("/usr/libexec/getty" vs "/usr/libexec/getty Pc") 



## look for anomalies 
```
# audit networking applications
netstat -nlpa | egrep '(LIST|ESTA)'

# common file informations
file FILEX | grep "not stripped"
strings -a FILEX

# malware sometimes hides as common name, but fail to set same timestamp as other files in directory
ls -ltr

# check the assembly
objdump -M intel -d FILEX

# check unusual files with flags
## Linux -- immutable flags
lsattr
## FreeBSD -- schg,uschg
find / -exec ls -lo {} \; 2>/dev/null | grep schg
```
