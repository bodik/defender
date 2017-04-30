# Linux Baselining

check used binaries
```
date
which ps netstat ls
export | grep PATH
export | grep LD_
```

get basic info
```
hostname -f
cat /etc/issue
uname -a
lsmod
cat /etc/passwd
cat /etc/nsswitch.conf
cat /etc/syslog.conf
dpkg -l
rpm -qa
crontab -l
find /var/spool/crontab -type f -exec cat {} \;
```

get runtime info
```
ps faxu
netstat -nlpaeo
```

networking
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

filesystem
```
mount
df -h
find / -xdev -print0 | xargs -0 stat -c "%Y %X %Z %A %U %G %n" > timestamps.dat
timeline-decorator.py < timestamps.dat | sort -n > timeline.txt
tar czf /tmp/$(hostname -f)-baseline.tgz /bin /boot /etc /home /lib /lib64 /opt /root /sbin /usr /var [LOCALDIRS]
```
[timeline-decorator.py](../forensics/timeline-decorator.py)
