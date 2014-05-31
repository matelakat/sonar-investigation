#!/bin/bash
set -eux

WORKDIR=.sonar_investigation
WORKDIR=$(readlink -f "$WORKDIR")


mkdir -p "$WORKDIR/sonar-vm"

[ -e "$WORKDIR/sonar-vm/hda.qcow2" ] || (
    qemu-img create "$WORKDIR/sonar-vm/hda.qcow2" 4G

    qemu-system-x86_64 \
        -enable-kvm \
        -m 2048 \
        -vnc :1 \
        -boot d \
        -cdrom "$WORKDIR/REMASTERED_ISO/remastered.iso" \
        -drive file="$WORKDIR/sonar-vm/hda.qcow2",if=virtio
)

nohup qemu-system-x86_64 \
    -enable-kvm \
    -m 2048 \
    -vnc :1 \
    -boot c \
    -net user,hostfwd=tcp::4545-:22,hostfwd=tcp::9000-:9000 \
    -net nic,model=virtio \
    -drive file="$WORKDIR/sonar-vm/hda.qcow2",if=virtio &

while ! echo "ping" | nc localhost 4545 -w 1 | grep -q "OpenSSH"; do
    sleep 1
done

sshpass -p ubuntu \
    ssh -p 4545 \
        -o UserKnownHostsFile=/dev/null\
        -o StrictHostKeyChecking=no\
        ubuntu@localhost
