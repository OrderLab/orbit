#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR 

mkdir rel-orig rel-orbit

git clone git@github.com:OrderLab/obiwan-nginx.git code
cd code

git checkout 69983de8
./auto/configure --with-http_dav_module --with-debug --prefix=$SCRIPT_DIR/rel-orbit --with-ld-opt=-lorbit
make -j$(nproc)
make install

git checkout 967b1216
./auto/configure --with-http_dav_module --with-debug --prefix=$SCRIPT_DIR/rel-orig
make -j$(nproc)
make install

git checkout 0a199f00
./auto/configure --with-http_dav_module --with-debug --prefix=$SCRIPT_DIR/rel-segfault
make -j$(nproc)
make install
