#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

module load mysql/orig
if ! which mysqld > /dev/null 2>&1; then
	echo "Build of sysbench depends on a built MySQL. Please wait until apps has been built."
	exit 1
fi

git clone https://github.com/akopytov/sysbench sysbench-code
cd sysbench-code
git checkout 1.0.20

#export PATH="$PATH:$SCRIPT_DIR/../../apps/mysql/rel-orig/dist/bin"
export PATH="$PATH:/root/mysql/rel-orig/dist/bin"

./autogen.sh
./configure --prefix=$SCRIPT_DIR/sysbench
make -j$(nproc)
make install
