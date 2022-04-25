#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR 

module load userlib/dealloc

git clone https://github.com/OrderLab/obiwan-redis.git code
cd code
make distclean

function build {
	commit=$1
	target=$2
	patch=$3

	git checkout $commit
	[ ! -z "$patch" ] && git apply $SCRIPT_DIR/$patch
	make -j$(nproc)
	make install PREFIX=$SCRIPT_DIR/$target
	make distclean
	git checkout -- .
}

build 0122d7a rel-slowlog force-1000.patch
build 0122d7a rel-oom inject-oom.patch
build 0122d7a rel-cpu-hog inject-cpu-hog.patch
build 7d8197d rel-rdb
build 7d8197d rel-rdb-fault inject-fault.patch
build 7a0dc14 rel-orig
build 843b3d9 rel-memleak inject-delay.patch
build 0122d7a rel-slowlog-delay inject-delay-orbit.patch
