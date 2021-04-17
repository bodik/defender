#!/bin/sh

find / -user root -perm -4000 -exec ls -ldb {} \; 1>suid_files 2>/dev/null
find / -user root -perm -2000 -exec ls -ldb {} \; 1>sgid_files 2>/dev/null

tar czf etc.tar.gz /etc /lib/systemd

(cd / && find /var/lib/dpkg/info/ -name "*md5sums" -exec md5sum --check --quiet {} \;) 1>checksums_dpkg 2>&1
rpm -Va 1>checksums_rpm 2>&1

# prevent ansible from failing because of last command
echo 0
