#!/bin/bash

if [[ $1 = '-d' ]]; then
	DBG='-s -S'  # gdb debug options (port 1234; stop cpu)
else
	DBG=
fi
# in gdb console, `break start_kernel`

KVM=--enable-kvm
#KVM=

image=arch/x86/boot/bzImage
#image=bak/ddcd247bb/bzImage  # incr
#image=bak/fde60be41/bzImage  # no incr-newer
#image=bak/2da56b279/bzImage  # no delegate

# this kernel can successfully run mysql with 16 thds
#image=bak/7139b41ff/bzImage  # no incr

qemu-system-x86_64 -kernel $image \
    -hda qemu-image.img \
    -append "root=/dev/sda console=ttyS0 nokaslr cgroup_enable=memory loglevel=6" \
    ${DBG} \
    ${KVM} \
    -smp cores=4 -m 10G \
    -nographic
    #-serial stdio -display none
