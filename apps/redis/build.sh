#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR 

module load userlib/dealloc

git clone git@github.com:OrderLab/obiwan-redis.git code
cd code
make distclean

git checkout 0122d7a
git apply $SCRIPT_DIR/force-1000.patch
make -j$(nproc)
make install PREFIX=$SCRIPT_DIR/rel-slowlog
make distclean
git checkout -- .

git checkout 7d8197d
make -j$(nproc)
make install PREFIX=$SCRIPT_DIR/rel-rdb
make distclean

git checkout 7a0dc14a
make -j$(nproc)
make install PREFIX=$SCRIPT_DIR/rel-orig
make distclean

git checkout 843b3d91
git apply $SCRIPT_DIR/inject-delay.patch
make -j$(nproc)
make install PREFIX=$SCRIPT_DIR/rel-memleak
make distclean
git checkout -- .

git checkout 0122d7a
git apply $SCRIPT_DIR/inject-delay-orbit.patch
make -j$(nproc)
make install PREFIX=$SCRIPT_DIR/rel-slowlog-delay
make distclean
git checkout -- .
