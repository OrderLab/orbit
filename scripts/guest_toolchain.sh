#!/bin/bash

apt update
apt install -y neovim git cmake build-essential bison \
	libssl-dev libncurses5-dev pkg-config \
	automake autotools-dev libedit-dev libjemalloc-dev libncurses-dev \
	libpcre3-dev libtool python3-docutils python3-sphinx cpio
