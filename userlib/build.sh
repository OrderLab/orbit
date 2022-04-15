#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

mkdir -p rel-{plain,dealloc,reuse}/{include,lib}

git clone https://github.com/OrderLab/obiwan-userlib.git code
cd code
mkdir build

function build {
	commit=$1
	target=$2
	patch=$3

	cd $SCRIPT_DIR/code
	git checkout $commit
	[ -n "$patch" ] && git apply $SCRIPT_DIR/$patch

	cd build
	cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo
	make -j$(nproc)

	cd $SCRIPT_DIR/code
	# TODO: install script within cmake
	cp lib/include/orbit.h $SCRIPT_DIR/$target/include/
	cp build/lib/liborbit.so $SCRIPT_DIR/$target/lib/
	git checkout -- .
}

build b5ee3a2 rel-plain
build b5ee3a2 rel-reuse reuse.patch
build c5770e9 rel-dealloc
