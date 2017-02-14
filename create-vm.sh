#!/bin/bash

# Credit to jlebon https://github.com/jlebon
# Slides: http://jlebon.com/devconf/slides.pdf

set -euo pipefail

if [ $# -ne 2 ]; then
	echo "Usage: $0 <domain> <image.qcow2>"
	exit
fi

for util in genisoimage qemu-img virt-install; do
	if ! command -v $util >/dev/null; then
		echo "Please install $util"
		exit
	fi
done

domain=$1; shift
backing_file=$1; shift

echo -n "Creating domain $domain "

### create a cloud-init metadata ISO image

tmpdir=$(mktemp -d)
trap "rm -rf $tmpdir" EXIT

cat > $tmpdir/meta-data << EOF
instance-id: $domain-iid
local-hostname: $domain
EOF

cat > $tmpdir/user-data << EOF
#cloud-config
user: atomic-user
password: atomic
chpasswd: {expire: False}
ssh_pwauth: True
EOF

cidata="/var/lib/libvirt/images/$domain.cidata.iso"

genisoimage \
	-input-charset default \
	-output "$cidata" \
	-volid cidata \
	-joliet \
	-rock \
	-quiet \
	$tmpdir/user-data \
	$tmpdir/meta-data

### create a new disk image with the qcow2 as a backing file

qcow2="/var/lib/libvirt/images/$domain.qcow2"

qemu-img create -q -f qcow2 \
	-o "backing_file=$backing_file" "$qcow2"

### and finally, create the actual VM

virt-install --quiet --import --name="$domain" \
	--os-variant=fedora23 --ram=1536 --vcpus=1 \
	--disk path="$qcow2",format=qcow2,bus=virtio \
	--disk path="$cidata",device=cdrom,readonly=on \
	--network network=default --noautoconsole

echo "Use 'virsh domifaddr $domain' to get IP address."
echo "You can log in with username:atomic-user/password:atomic"
