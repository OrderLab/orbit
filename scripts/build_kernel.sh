#!/bin/bash
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR/../

git submodule update --init --remote kernel

cd kernel
cp $SCRIPT_DIR/orbit.config kernel/configs/
make x86_64_defconfig
make kvm_guest.config
make orbit.config

git checkout 7139b41f
make -j$(nproc)
cp arch/x86/boot/bzImage bzImage-7139b41f

git checkout ddcd247b
make -j$(nproc)
cp arch/x86/boot/bzImage bzImage-ddcd247b
