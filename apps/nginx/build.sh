#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR 

git clone git@github.com:OrderLab/obiwan-nginx.git code
cd code

git checkout 69983de8
./auto/configure --with-http_dav_module --with-debug --prefix=$SCRIPT_DIR/rel-orbit --with-ld-opt=-lorbit
make -j$(nproc)
make install
mkdir -p $SCRIPT_DIR/rel-orbit/html/dd/
chmod 777 $SCRIPT_DIR/rel-orbit/html/dd/
cp $SCRIPT_DIR/nginx.conf $SCRIPT_DIR/rel-orbit/conf/nginx.conf

git checkout 967b1216
./auto/configure --with-http_dav_module --with-debug --prefix=$SCRIPT_DIR/rel-orig
make -j$(nproc)
make install
mkdir -p $SCRIPT_DIR/rel-orig/html/dd/
chmod 777 $SCRIPT_DIR/rel-orig/html/dd/
cp $SCRIPT_DIR/nginx.conf $SCRIPT_DIR/rel-orig/conf/nginx.conf

git checkout 0a199f00
./auto/configure --with-http_dav_module --with-debug --prefix=$SCRIPT_DIR/rel-segfault
make -j$(nproc)
make install
mkdir -p $SCRIPT_DIR/rel-segfault/html/dd/
chmod 777 $SCRIPT_DIR/rel-segfault/html/dd/
cp $SCRIPT_DIR/nginx.conf $SCRIPT_DIR/rel-segfault/conf/nginx.conf
