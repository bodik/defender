#!/bin/sh

find / -user root -perm -4000 -exec ls -ldb {} \; 1>suid_files 2>/dev/null
find / -user root -perm -2000 -exec ls -ldb {} \; 1>sgid_files 2>/dev/null

tar czf etc.tar.gz /etc

freebsd-update IDS 1>checksums_freebds
pkg check -s -a 1>checksums_pkg

# prevent ansible from failing because of last command
echo 0
