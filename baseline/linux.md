# Linux Baselining

## check used binaries
```
date
which ps netstat ls
export | grep PATH
export | grep LD_
```



## basic info
```
hostname -f
cat /etc/issue
uname -a
lsmod
cat /etc/syslog.conf
crontab -l
find /var/spool/crontab -type f -exec cat {} \;
```



## networking
```
ifconfig -a
ip -4 neigh
ip -6 neigh
route -n
route -6n
sysctl net.ipv4 net.ipv6 | grep forward
cat /etc/resolv.conf
iptables-save
ip6tables-save
```



## runtime info
```
ps faxu
netstat -nlpaeo
w
last
```



## users
```
cat /etc/nsswitch.conf
cat /etc/passwd
cat /etc/group
cat /etc/shadow
```



## software
```
dpkg -l
rpm -qa
```



## filesystem
```
mount
df -h
tar czf /tmp/$(hostname -f)-baseline.tgz /bin /boot /etc /home /lib /lib64 /opt /root /sbin /usr /var [LOCALDIRS]
```
[generate timeline](/#!forensics/linux.md#generate_timeline)
