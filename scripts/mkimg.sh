IMG=qemu-image.img
DIR=mount-point.dir
qemu-img create $IMG 45G
mkfs.ext4 $IMG
mkdir $DIR
sudo mount -o loop $IMG $DIR
sudo debootstrap --arch amd64 buster $DIR
sudo umount $DIR
