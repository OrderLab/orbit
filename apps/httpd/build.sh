#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR 

git clone https://github.com/OrderLab/obiwan-httpd.git code
cd code

module load userlib/reuse

function build {
	commit=$1
	target=$2
	appendix=$3
	flags=$4

	git checkout $commit
	./buildconf
	./configure --with-included-apr --prefix=$SCRIPT_DIR/$target CFLAGS="-O3" $flags
	make -j$(nproc)
	make install
	make clean
	$SCRIPT_DIR/gen_config.sh $SCRIPT_DIR/$target/ $appendix
}

build 3e3b673 rel-proxy config-appendix LDFLAGS="-lorbit"
build 48ff29d rel-watchdog config-appendix LDFLAGS="-lorbit"

git checkout 48ff29d
git apply < $SCRIPT_DIR/watchdog-inject-wait.patch
./buildconf
./configure --with-included-apr --prefix=$SCRIPT_DIR/rel-watchdog-inject CFLAGS="-O3" LDFLAGS="-lorbit"
make -j$(nproc)
make install
make clean
git checkout -- .
$SCRIPT_DIR/gen_config.sh $SCRIPT_DIR/rel-watchdog-inject/ config-appendix

build 2c250083 rel-orig config-appendix
build 296a0ae5d rel-segfault config-appendix-segfault
