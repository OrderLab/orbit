#!/bin/bash
set -e

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE-$0}")"/..; pwd)

cd $ROOT_DIR

git submodule update --init --remote userlib

cd userlib
mkdir -p build
mkdir -p build/rel-{plain,dealloc,reuse}/{include,lib}

function build {
	commit=$1
	target=$2
	patch=$3

	cd $ROOT_DIR/userlib
	git checkout $commit
	[ -n "$patch" ] && git apply $patch

	cd build
	cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo
	make -j$(nproc)

	cd $ROOT_DIR/userlib
	# TODO: install script within cmake
	cp lib/include/orbit.h build/$target/include/
	cp build/lib/liborbit.so build/$target/lib/
	git checkout -- .
}

build b5ee3a2 rel-plain
build b5ee3a2 rel-reuse $ROOT_DIR/patches/userlib_reuse.patch
build c5770e9 rel-dealloc
