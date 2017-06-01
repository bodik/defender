# Linux forensics

## generate timeline
```
find / -xdev -print0 | xargs -0 stat -c "%Y %X %Z %A %U %G %n" > timestamps.dat
timeline-decorator.py < timestamps.dat | sort -n > timeline.txt
```
[timeline-decorator.py](../tools/timeline-decorator.py)




## check against package manager hashes
even if you know that you cann't fully trust them

```
# Debian GNU/Linux
cd / && find /var/lib/dpkg/info/ -name "*md5sums" -exec md5sum -c {} \; | grep -v OK

# FreeBSD
pkg check -s -a
```




## places to hide malware/backdoors/persistence
* /etc/inittab
* init files (/etc/init.d, /etc/init, /lib/systemd/system, ...)
* preloaded libs (/etc/ld.so.*)
* rc files (~/.bashrc, ~/.bash_profile, ~/.profile, ...)
* crontabs
* /etc/pam.d
* additional files within web applications
* .htaccess bind php to any mimetime/filename





## look for anomalies 
```
# common file informations
file FILEX | grep "not stripped"
strings -a FILEX

# malware sometimes hides as common name, but fail to set same timestamp as other files in directory
ls -ltr

# check the assembly
objdump -M intel -d FILEX
```



