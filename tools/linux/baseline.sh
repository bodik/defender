#!/bin/sh

# setup
mkdir /root/baseline
chmod 700 /root/baseline
cd /root/baseline || exit 1
date > date.txt


# runtime
export > export.txt
hostname -f > hostname.txt
uname -a > uname.txt
lsmod > lsmod.txt
ps faxue > psfaxue.txt
ps faxje > psfaxje.txt
ls -lR /proc > proc.txt
df -h > df.txt
mount > mount.txt


# user accounts
cp /etc/passwd .
cp /etc/group .
cp /etc/shadow .
w > w.txt
last > last.txt


# config
crontab -l > crontabs.txt
find /var/spool/cron -type f -ls -exec cat {} \; >> crontabs.txt
find /etc -path '*cron*' -type f -ls -exec cat {} \; >> crontabs.txt
dpkg -l > dpkg.txt
rpm -qa > rpm.txt


# networking
ifconfig -a > ifconfig.txt
cp /etc/resolv.conf .
ip neigh show > ipneighbors.txt
iptables-save > iptables.txt
ip6tables-save > ip6tables.txt
netstat -nlpaeo > netstat.txt
route -4n > route4.txt
route -6n > route6.txt
sysctl net.ipv4 net.ipv6 | grep forward > forwarding.txt


# timeline
find / -xdev -print0 | xargs -0 stat -c "%Y %X %Z %A %U %G %n" >> timeline-timestamps.dat
