#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

apt update
apt install -y neovim git psmisc procps tmux cmake build-essential bison \
	libssl-dev libncurses5-dev pkg-config python3 \
	automake autotools-dev libedit-dev libjemalloc-dev libncurses-dev \
	libpcre3-dev libtool python3-docutils python3-sphinx cpio \
	llvm-6.0 llvm-6.0-dev llvm-6.0-tools llvm-6.0-runtime llvm-6.0-doc llvm-6.0-examples \
	libllvm6.0 clang-6.0 clang-tools-6.0 clang-6.0-doc clang-6.0-examples clang-format-6.0 \
	clang-tidy-6.0 libclang-6.0-dev libclang-common-6.0-dev libclang1-6.0 python-clang-6.0 lld-6.0 \
	maven environment-modules libcurl4-openssl-dev nginx

cp $SCRIPT_DIR/nginx-orbit-test /etc/nginx/sites-enabled/orbit-test
systemctl disable nginx
systemctl stop nginx
mkdir -p /var/www/rep{1,2}
cp $SCRIPT_DIR/1k.html /var/www/rep1/index.html
cp $SCRIPT_DIR/1k.html /var/www/rep2/index.html
echo "127.0.0.1 fe01 fe02 fe03" >> /etc/hosts
