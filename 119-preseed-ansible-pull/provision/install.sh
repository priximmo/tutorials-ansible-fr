#!/usr/bin/bash

# Let's Go !! #################################################


virt-install \
	--name deb \
	--vcpus=4 \
	--ram=12288 \
	--location="http://ftp.fr.debian.org/debian/dists/Debian10.8/main/installer-amd64/" \
	--initrd-inject=preseed.cfg \
	--extra-args="auto console=ttyS0,115200n8 serial" \
	--graphics none \
	--console pty,target_type=serial \
	--extra-args="ks=file:/preseed.cfg" \
	--network default,model=virtio \
	--os-type=linux \
	--os-variant=debian10 \
	--disk=pool=default,size=50,format=qcow2,bus=virtio
