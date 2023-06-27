# Forensics

## acquire forensic evidence from offline media
```
fdisk -l > YYYYMMDD-casetag-DISKID.fdisk
dd if=/dev/disk bs=8M | gzip -cv9 > YYYYMMDD-casetag-DISKID.dd.gz
```

* make best_evidence and working_evidence copies
* use losetup, kpartx, mount for reading the data
* when creating image with `dd` note the required usage of `conv=noerror,sync` and
  it's sideeffect when `bs=` does not align with device size, thus padding last
  block with zeroes which results into different hash.
  * flab ft1 evidence acquisition
  * https://forensics.wiki/dd/#tips


## mount qcow
```
modprobe nbd max_part=63
qemu-nbd -c /dev/nbd0 image.img
mount /dev/nbd0p1 /mnt/image
```



## log2timeline/plaso
```
# install with docker
sh -c "echo deb https://apt.dockerproject.org/repo debian-jessie main > /etc/apt/sources.list.d/docker.list"
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
apt-get install apt-transport-https
apt-get update
apt-get install docker-engine
docker ps
docker pull log2timeline/plaso
docker run -t -i --entrypoint=/bin/bash -v /data:/data log2timeline/plaso

# extract data
log2timeline.py output.zip input.img
pinfo.py output.zip
psort.py -w output.txt output.zip
```


## get borntimes from NTFS using fls
```
fls -r -m / /dev/mapper/nbd0p2 > fls-timeline.txt
mactime -y -d -b fls-timeline.txt > fls-timeline-mactimes.txt
```


## extract memory image from OpenNebula checkpoint

warning: does not work anymore
https://github.com/juergh/lqs2mem.py
