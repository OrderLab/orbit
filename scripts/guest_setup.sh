#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

if [[ $(id -u) != 0 ]]; then
	echo Please run this script as root.
	exit 1
fi

apt update
apt install -y xterm neovim git psmisc procps tmux cmake build-essential bison \
	libssl-dev libncurses5-dev pkg-config python3 zlib1g-dev curl cgroup-tools \
	automake autotools-dev libedit-dev libjemalloc-dev libncurses-dev \
	libpcre3-dev libtool libtool-bin python3-docutils python3-sphinx cpio \
	llvm-6.0 llvm-6.0-dev llvm-6.0-tools llvm-6.0-runtime llvm-6.0-doc \
	libllvm6.0 clang-6.0 clang-tools-6.0 clang-6.0-doc clang-format-6.0 \
	clang-tidy-6.0 libclang-6.0-dev libclang-common-6.0-dev libclang1-6.0 python-clang-6.0 lld-6.0 \
	maven environment-modules tclsh libcurl4-openssl-dev nginx python3-pip python3-pandas

cp $SCRIPT_DIR/nginx-orbit-test /etc/nginx/sites-enabled/orbit-test
systemctl disable nginx
systemctl stop nginx
mkdir -p /var/www/rep{1,2}
cp $SCRIPT_DIR/1k.html /var/www/rep1/index.html
cp $SCRIPT_DIR/1k.html /var/www/rep2/index.html
echo "127.0.0.1 fe01 fe02 fe03" >> /etc/hosts

echo '/dev/sda / ext4 errors=remount-ro,acl 0 1' > /etc/fstab
passwd -d root
echo 'resize > /dev/null 2>&1' >> ~/.bashrc
echo 'if [[ $TMUX = "" ]]; then shutdown -h now; fi' > ~/.bash_logout
