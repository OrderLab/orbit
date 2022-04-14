#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR 

module load userlib/reuse

git clone git@github.com:OrderLab/obiwan-nginx.git code
cd code

function build {
	commit=$1
	target=$2
	flags=$3

	git checkout $commit
	./auto/configure --with-http_dav_module --with-debug --prefix=$SCRIPT_DIR/$target $flags
	make -j$(nproc)
	make install
	mkdir -p $SCRIPT_DIR/$target/html/dd/
	chmod 777 $SCRIPT_DIR/$target/html/dd/
	cp $SCRIPT_DIR/nginx.conf $SCRIPT_DIR/$target/conf/nginx.conf
}

build 69983de8 rel-orbit --with-ld-opt=-lorbit
build 967b1216 rel-orig
build 0a199f00 rel-segfault
