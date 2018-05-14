#!/usr/bin/python
# nixon's security @ taipei
#find / -xdev -print0 | xargs -0 stat -c "%Y %X %Z %A %U %G %n" >> timestamps.dat
#timeline-decorator.py < timestamps.dat | sort -n > timeline.txt

import sys, time
def print_line(flags, t, mode, user, group, name):
	print t, '\"'+time.ctime(float(t))+'\"', flags, mode, user, group, name

for line in sys.stdin:
	line = line[:-1]
	(m, a, c, mode, user, group, name) = line.split(" ", 6)
	if m == a:
		if m == c:
			print_line("mac", m, mode, user, group, name)
		else:
			print_line("ma-", m, mode, user, group, name)
			print_line("--c", c, mode, user, group, name)
	else:
		if m == c:
			print_line("m-c", m, mode, user, group, name)
			print_line("-a-", a, mode, user, group, name)
		else:
			print_line("m--", m, mode, user, group, name)
			print_line("-a-", a, mode, user, group, name)
			print_line("--c", c, mode, user, group, name)

