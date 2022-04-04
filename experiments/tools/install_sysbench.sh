#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

git clone https://github.com/akopytov/sysbench sysbench-code
cd sysbench-code
git checkout 1.0.20

#export PATH="$PATH:$SCRIPT_DIR/../../apps/mysql/rel-orig/dist/bin"
export PATH="$PATH:/root/mysql/rel-orig/dist/bin"

./autogen.sh
./configure --prefix=$SCRIPT_DIR/sysbench
make -j$(nproc)
make install
