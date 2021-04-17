#!/bin/sh

# setup
date 1>date.txt

# runtime
export 1>export.txt
set 1>set.txt
declare -f 1>declare.txt
hostname -f 1>hostname.txt
uname -a 1>uname.txt
kldstat 1>kldstat.stats
ps faxu 1>psfaxu.txt
ps faxue 1>psfaxue.txt
ps faxje 1>psfaxje.txt
(mount | grep procfs) || mount -t procfs proc /proc
find /proc -ls 1>proc.txt
df -h 1>df.txt
mount 1>mount.txt
lsof -b -l -P -n -o -R 1>lsof.txt
ipcs -a 1>ipcs.txt
dmesg 1>dmesg.txt

# user accounts
cp /etc/passwd .
cp /etc/master.passwd .
cp /etc/group .
cp /etc/shadow .
w 1>w.txt
last 1>last.txt
lastlog 1>lastlog.txt

# config
crontab -l 1>crontabs.txt
find /var/cron/ -type f -ls -exec cat {} \; 1>>crontabs.txt
find /etc -path '*cron*' -type f -ls -exec cat {} \; 1>>crontabs.txt
pkg info 1>pkg_info.txt
## TODO: ports

# networking
ifconfig -a 1>ifconfig.txt
arp -an 1>arpan.txt
netstat -r 1>route.txt
netstat -an 1>netstat.txt
sockstat -lcSsv 1>sockstat.txt

sysctl net.inet net.inet6 | grep forward 1>forwarding.txt
cp /etc/resolv.conf .

# firewall
pfctl -sa 1>pfctl_sa.txt

# services
service -e 1>services.txt

# timeline
find / -xdev -print0 | xargs -0 stat -f "%a %m %c %Sp %Su %Sg %N" 1>>timeline-timestamps.dat

# prevent ansible from failing because of last command
exit 0
