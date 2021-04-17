# FreeBSD

* http://bhami.com/rosetta.html cookies whichOses=3,6
* default corn-shell is better to be replaced with /bin/sh
* `truss` can be used to trace programs
* proc is not mounted by default -- `mount -t procfs proc /proc`
* networking setup in `/etc/rc.conf`
* password recovery -- boot single mode, `mount -u -a -o rw`, `passwd`, `reboot`
* auditd can be enabled (role auditd), audit logs are in binary format, can be translated via `praudit -l /var/audit/current`



## pf - packet filter

* start pf
```
kldload pf  # not required, loads kernel module

echo "pf_enable=yes" >> /etc/rc.conf  # enables pf on boot
sysrc pf_enable=yes  # alternative
service pf start|stop  # starts the service, note it might drop current if keep state table empty
```

* packet filter logging must be enabled at boot or additional interfaces created with ifconfig
* logging is triggered via action `log` in pf rules
* log is rotated according to `/etc/newsyslog.conf.d/pf.conf`
```
sysrc pflog_enable=yes
tcpdump -n -e -ttt -r /var/log/pflog  # read backlog
tcpdump -n -e -ttt -i pflog0  # read live
```

* sample config
```
cat >/etc/pf.conf <<__EOF__
set skip on lo
block in log all
pass in proto tcp from any to any port 22 keep state
pass in quick proto icmp all keep state
pass out log all keep state
__EOF__
```


## os/package patch management

* /etc/pkg/FreeBSD.conf should be used to fix repository used by `pkg` if system is not up-to-date

* update os
```
# security patches
freebsd-update fetch
freebsd-update install

# major upgrade
freebsd-update -r 12.2-RELEASE upgrade
```

* pkg/ports update
```
portsnap fetch update
pkg version -l "<"
cd /usr/ports/ports-mgmt/portmaster
make install clean
portmaster -L
```

* software via `pkg`
```
pkg install <package>
pkg info [package]
```

* software via `ports`
```
portsnap auto
portsnap fetch extract update

pkg search -o nmap
cd /usr/ports/security/nmap
make install
make deinstall
```

* which package a file comes from
```
pkg which /usr/local/bin/python3
pkg list | grep file
find /usr/ports -name pkg-plist -exec grep -H sshd {} \;
```

* check system integrity
```
freebsd-update IDS
pkg check -a -s
ports -- imposible without external tool
```

* there's no simple way how to replace corrupted binary file comming from base
  * either they must be found in /var/db/freebsd-update via INDEX and upacked by hand
  * or compiled from source https://docs.freebsd.org/en/books/handbook/cutting-edge/#makeworld

```
cd /usr/src
git clone https://git.FreeBSD.org/src.git .
make buildworld
	>> yields approx. 10h build, results compiled to /usr/obj
```


## misc

* user database might get out-of-sync

```
# pkg install git
...
Creating group '_tss' with gid '601'.
===> Creating users
Creating user '_tss' with uid '601'.
pw: user '_tss' disappeared during update
pkg: PRE-INSTALL script failed

## sync to fix
# pwd_mkdb -p /etc/master.passwd
# pkg install git
```
