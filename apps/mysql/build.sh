#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

module load userlib/plain

boost_dir=$SCRIPT_DIR/boost_1_59_0

build_dir=$SCRIPT_DIR/build

git clone https://github.com/OrderLab/obiwan-mysql.git code
srcdir=$SCRIPT_DIR/code

function build {
	commit=$1
	dest=$SCRIPT_DIR/$2
	patch=$3

	rm -rf $build_dir
	mkdir -p $build_dir

	dist=$dest/dist
	data=$dest/data

	mkdir -p $dist $data

	cd $srcdir
	git checkout $commit
	if [ ! -z "$patch" ]; then
		git apply $SCRIPT_DIR/$patch
	fi

	cd $build_dir
	cmake $srcdir  -DCMAKE_INSTALL_PREFIX=$dist \
		-DMYSQL_DATADIR=$data -DCMAKE_BUILD_TYPE=RelWithDebInfo \
		-DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DMYSQL_MAINTAINER_MODE=false \
		-DDOWNLOAD_BOOST=1 -DWITH_BOOST=$boost_dir \
		-DWITH_EMBEDDED_SERVER=0 -DWITH_EMBEDDED_SHARED_LIBRARY=0

	make -j$(nproc)
	make install

	if [ ! -f $dist/etc/my.cnf ]; then
		mkdir -p $dist/etc
		cp $SCRIPT_DIR/my.cnf $dist/etc/
		echo "log-error       = ${dist}/error.log" >> $dist/etc/my.cnf

		cd $dist
		bin/mysqld --initialize-insecure --user=root
	fi

	cd $srcdir
	git checkout -- .

	rm -rf $build_dir
}

function build_orig {
    build 0fff8c36 rel-orig
}
function build_orbit {
    build 23ef2177 rel-orbit
}
function build_fork {
    build 98308f96 rel-fork
    pkill -9 mysqld
}
function build_sync {
    build 011edc32 rel-sync sync-mode.patch
}
function build_all {
    for t in orig orbit fork sync; do
        build_$t
    done
}

for t in "$@"; do
    build_$t
done

if [[ "$@" == "" ]]; then
    build_all
fi
