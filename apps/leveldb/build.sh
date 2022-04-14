#!/bin/bash

module load userlib/dealloc

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR 

git clone --recurse-submodules git@github.com:OrderLab/obiwan-leveldb.git code
cd code
mkdir -p build && cd build

git checkout acf8ea1a
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$SCRIPT_DIR/rel-orbit ..
make -j$(nproc)
mkdir -p $SCRIPT_DIR/rel-orbit/bin
cp db_bench $SCRIPT_DIR/rel-orbit/bin

git checkout 1730a1a0
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$SCRIPT_DIR/rel-orig ..
make -j$(nproc)
mkdir -p $SCRIPT_DIR/rel-orig/bin
cp db_bench $SCRIPT_DIR/rel-orig/bin
