#!/bin/sh

# setup
date 1>date.txt

# runtime
export 1>export.txt
set 1>set.txt
declare -f 1>declare.txt
hostname -f 1>hostname.txt
uname -a 1>uname.txt
lsmod 1>lsmod.txt
ps faxu 1>psfaxu.txt
ps faxuewww 1>psfaxuewww.txt
ps faxje 1>psfaxje.txt
find /proc -ls 1>proc.txt
df -h 1>df.txt
mount 1>mount.txt
lsof -b -l -P -X -n -o -R -U 1>lsof.txt
ipcs -a -t 1>ipcs_t.txt
ipcs -a -p 1>ipcs_p.txt
ipcs -a -c 1>ipcs_c.txt
ipcs -a -l 1>ipcs_l.txt
dmesg 1>dmesg.txt

# user accounts
cp /etc/passwd .
cp /etc/group .
cp /etc/shadow .
w 1>w.txt
last 1>last.txt
lastlog 1>lastlog.txt

# config
crontab -l 1>crontabs.txt
find /var/spool/cron -type f -ls -exec cat {} \; 1>>crontabs.txt
find /etc -path '*cron*' -type f -ls -exec cat {} \; 1>>crontabs.txt
dpkg -l 1>dpkg.txt
rpm -qa 1>rpm.txt

# networking
ifconfig -a 1>ifconfig.txt
arp -an 1>arpan.txt
route -4n 1>route4.txt
route -6n 1>route6.txt
netstat -nlpaeo 1>netstat.txt
ss -anempi 1>ss.txt

ip a 1>ipa.txt
ip neigh show 1>ipneighbors.txt
ip route 1>iproute.txt
ip -6 route 1>iproute6.txt

sysctl net.ipv4 net.ipv6 | grep forward 1>forwarding.txt
cp /etc/resolv.conf .

# firewall
iptables-save 1>iptables-save.txt
ip6tables-save 1>ip6tables-save.txt
ebtables-save 1>ebtables-save.txt
iptables -L -nv --line-numbers 1>iptables_l.txt
iptables -t nat -L -nv --line-numbers 1>iptables_l_nat.txt
ip6tables -L -nv --line-numbers 1>ip6tables_l.txt
ip6tables -t nat -L -nv --line-numbers 1>ip6tables_l_nat.txt
nft list ruleset 1>nft.txt

# services
systemctl list-units --all 1>systemd-units.txt
systemctl list-timers --all 1>systemd-timers.txt

# timeline
find / -xdev -print0 | xargs -0 stat -c "%Y %X %Z %A %U %G %n" 1>>timeline-timestamps.dat

# prevent ansible from failing because of last command
exit 0
