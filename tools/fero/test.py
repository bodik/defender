
import argparse
import psutil
import socket
import time

def split_len(seq, length):
    return [seq[i:i+length] for i in range(0, len(seq), length)]

def print_proc(procd, ident):
	out = []

	if procd["pid"] in printed_pids:
		return out

	out.append("%-30s %-5d %-5d %-20s %-50s %s" % (procd["username"], procd["pid"], procd["ppid"], ("  "*ident)+(procd["name"]), procd["exe"], procd["cwd"]))
	if args.c:
		if procd["connections"]:
			for i in sorted(procd["connections"], key=lambda k: k.status):
				out.append("\t%s"%str(i))
	if args.m:
		if procd["memory_maps"]:
			for i in sorted(procd["memory_maps"], key=lambda k: k.path):
				out.append("\t%s"%str(i))
	
	printed_pids.append(procd["pid"])

	for other in processes:
		if (other["pid"] not in printed_pids) and (procd["pid"]==other["ppid"]):
			out = out + print_proc(other, ident+1)
	
	return out




parser = argparse.ArgumentParser()
parser.add_argument('-c', action='store_true')
parser.add_argument('-m', action='store_true')
args = parser.parse_args()

out = []
printed_pids = []


processes = [tmp.as_dict() for tmp in psutil.process_iter()]
processes.sort(key=lambda x: x["pid"])

for proc in processes:
	out = out+print_proc(proc, 0)

data = "\n".join(out)
print data

