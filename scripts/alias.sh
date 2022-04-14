export __ORBIT_ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/../" &> /dev/null && pwd )
export __ORBIT_IMAGE_FILE=$__ORBIT_ROOT_DIR/qemu-image.img
export __ORBIT_MOUNT_DIR=$__ORBIT_ROOT_DIR/mount-point.dir
function mount_qemu_image() {
    sudo mount -o loop $__ORBIT_IMAGE_FILE $__ORBIT_MOUNT_DIR && \
    sudo mount -o bind,ro /dev $__ORBIT_MOUNT_DIR/dev && \
    sudo mount -o bind,ro /dev/pts $__ORBIT_MOUNT_DIR/dev/pts && \
    sudo mount -t proc none $__ORBIT_MOUNT_DIR/proc
}
function unmount_qemu_image() {
    sudo umount $__ORBIT_MOUNT_DIR/dev/pts
    sudo umount $__ORBIT_MOUNT_DIR/dev
    sudo umount $__ORBIT_MOUNT_DIR/proc
    sudo umount $__ORBIT_MOUNT_DIR
}
# Mount/unmount disk image (do not mount if qemu is running)
alias m='pgrep qemu && echo "QEMU is running (with pid above)" || mount_qemu_image'
alias um=unmount_qemu_image
# Chroot into mounted disk image
# (`sudo' is used for setting $HOME and other variables correctly)
alias ch='sudo -i chroot $__ORBIT_MOUNT_DIR'
# Run the VM (fail if still mounted)
alias r='um; (mount | grep $__ORBIT_MOUNT_DIR) || $__ORBIT_ROOT_DIR/scripts/run-kernel.sh'
# Force kill QEMU
alias k='killall qemu-system-x86_64'
