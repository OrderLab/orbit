#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR/../

IMG=qemu-image.img
DIR=mount-point.dir
qemu-img create $IMG 40G
mkfs.ext4 $IMG
mkdir $DIR
sudo mount -o loop $IMG $DIR
sudo debootstrap --arch amd64 buster $DIR
sudo umount $DIR
