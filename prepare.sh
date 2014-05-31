#!/bin/bash
set -eux

WORKDIR=.sonar_investigation

if ! [ -e "$WORKDIR" ]; then
    mkdir "$WORKDIR"
fi

WORKDIR=$(readlink -f "$WORKDIR")


ISOURL="http://releases.ubuntu.com/14.04/ubuntu-14.04-server-amd64.iso"

mkdir -p "$WORKDIR/UBUNTU_ISO"
(
    cd "$WORKDIR/UBUNTU_ISO"
    wget -nc "$ISOURL"
)

[ -e "$WORKDIR/python-env" ] || (
    virtualenv "$WORKDIR/python-env"
    set +u
    source "$WORKDIR/python-env/bin/activate"
    pip install https://github.com/lakat/unattended-iso/archive/0.2.0.zip
    set -u
)

set +u
source "$WORKDIR/python-env/bin/activate"
set -u

mkdir -p "$WORKDIR/REMASTERED_ISO"

[ -e "$WORKDIR/REMASTERED_ISO/remastered.iso" ] || {
    uiso-ubuntu $WORKDIR/UBUNTU_ISO/*.iso \
        "$WORKDIR/REMASTERED_ISO/remastered.iso"
}
