#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

module load userlib/plain

git clone git@github.com:OrderLab/obiwan-varnish.git code
cd code

git checkout 4d36eae9
./autogen.sh
./configure --prefix=$SCRIPT_DIR/rel-orbit LDFLAGS='-lorbit' CFLAGS="-O2 -ggdb"
make -j$(nproc)
make install

git checkout c5626ecea
./autogen.sh
./configure --prefix=$SCRIPT_DIR/rel-orig CFLAGS="-O2 -ggdb"
make -j$(nproc)
make install
