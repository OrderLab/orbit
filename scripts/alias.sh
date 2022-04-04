export image_file=qemu-image.img
export mount_dir=mount-point.dir
function mount_qemu_image() {
    sudo mount -o loop $image_file $mount_dir && \
    sudo mount -o bind,ro /dev $mount_dir/dev && \
    sudo mount -o bind,ro /dev/pts $mount_dir/dev/pts && \
    sudo mount -t proc none $mount_dir/proc
}
function unmount_qemu_image() {
    sudo umount $mount_dir/dev/pts
    sudo umount $mount_dir/dev
    sudo umount $mount_dir/proc
    sudo umount $mount_dir
}
# Mount/unmount disk image (do not mount if qemu is running)
alias m='pgrep qemu && echo "QEMU is running" || mount_qemu_image'
alias um=unmount_qemu_image
# Chroot into mounted disk image
# (`sudo' is used for setting $HOME and other variables correctly)
alias ch='sudo -i chroot $mount_dir'
# Run the VM (fail if still mounted)
alias r='um; (mount | grep $mount_dir) || ./scripts/run-kernel.sh'
# Force kill QEMU
alias k='killall qemu-system-x86_64'
