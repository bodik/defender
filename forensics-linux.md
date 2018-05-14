# Linux forensics

## generate timeline
```
find / -xdev -print0 | xargs -0 stat -c "%Y %X %Z %A %U %G %n" > timestamps.dat
timeline-decorator.py < timestamps.dat | sort -n > timeline.txt
```
[timeline-decorator.py](../tools/timeline-decorator.py)




## check against package manager hashes
even if you know that you cann't fully trust them
 <table>

<tr><td>Debian GNU/Linux</td><td>
	`cd / && find /var/lib/dpkg/info/ -name "*md5sums" -exec md5sum -c {} \; | grep -v OK`
</td></tr>

<tr><td>RedHat based distributions</td><td>
	`rpm -Va`
</td></tr>

<tr><td>FreeBSD</td><td>
	`pkg check -s -a`
</td></tr>

</table>



## places to hide malware/backdoors/persistence
* kernel modules, initrd/initramdisk
* init files (/etc/inittab, /etc/init.d/, /etc/init/, /lib/systemd/system/, ...)
* preloaded libs (/etc/ld.so.*)
* rogue pam modules
* snmpd.conf allowing external command executions
* crontabs, atjobs
* rc files (~/.bashrc, ~/.bash_profile, ~/.profile, ...)
* additional files within web applications, .htaccess bind php to any mimetime/filename





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
```
