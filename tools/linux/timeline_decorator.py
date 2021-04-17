#!/usr/bin/python
"""
nixon's security @ taipei

Linux: find / -xdev -print0 | xargs -0 stat -c "%Y %X %Z %A %U %G %n" >> timestamps.dat
FreeBSD: find / -xdev -print0 | xargs -0 stat -f "%a %m %c %Sp %Su %Sg %N" >> timestamps.dat
timeline_decorator.py < timestamps.dat | sort -n > timeline.txt
"""

import sys
import time


def print_line(flags, time_, mode, user, group, name):  # pylint: disable=too-many-arguments
    """print"""

    print(time_, '\"'+time.ctime(float(time_))+'\"', flags, mode, user, group, name)


def main():
    """main"""
    for line in sys.stdin:
        line = line[:-1]
        (mtime, atime, ctime, mode, user, group, name) = line.split(" ", 6)
        if mtime == atime:
            if mtime == ctime:
                print_line("mac", mtime, mode, user, group, name)
            else:
                print_line("ma-", mtime, mode, user, group, name)
                print_line("--c", ctime, mode, user, group, name)
        else:
            if mtime == ctime:
                print_line("m-c", mtime, mode, user, group, name)
                print_line("-a-", atime, mode, user, group, name)
            else:
                print_line("m--", mtime, mode, user, group, name)
                print_line("-a-", atime, mode, user, group, name)
                print_line("--c", ctime, mode, user, group, name)


if __name__ == '__main__':
    main()
