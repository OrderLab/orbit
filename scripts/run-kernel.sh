#!/bin/bash

if [[ $1 = '-d' ]]; then
	DBG='-s -S'  # gdb debug options (port 1234; stop cpu)
	shift
else
	DBG=
fi
# in gdb console, `break start_kernel`

if [[ $1 = 'formysql' ]]; then
	image=bzImage-7139b41f
elif [ -n "$1" ] && [[ $1 != 'formysql' ]]; then
	echo Unknown kernel version "\"$1\"".
	exit 1
else
	image=bzImage-ddcd247b
fi

KVM=--enable-kvm
#KVM=

qemu-system-x86_64 -kernel $image \
    -hda qemu-image.img \
    -append "root=/dev/sda console=ttyS0 nokaslr cgroup_enable=memory loglevel=6" \
    ${DBG} \
    ${KVM} \
    -smp cores=4 -m 10G \
    -nographic
    #-serial stdio -display none
