#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR 

git clone git@github.com:OrderLab/obiwan-httpd.git code
cd code

module load userlib/plain

git checkout 3e3b673
./buildconf
./configure --with-included-apr --prefix=$SCRIPT_DIR/rel-proxy CFLAGS="-O3" LDFLAGS="-lorbit"
make -j$(nproc)
make install
make clean
$SCRIPT_DIR/gen_config.sh $SCRIPT_DIR/rel-proxy/ config-appendix

git checkout 48ff29d
./buildconf
./configure --with-included-apr --prefix=$SCRIPT_DIR/rel-watchdog CFLAGS="-O3" LDFLAGS="-lorbit"
make -j$(nproc)
make install
make clean
$SCRIPT_DIR/gen_config.sh $SCRIPT_DIR/rel-watchdog/ config-appendix

git checkout 2c250083
./buildconf
./configure --with-included-apr --prefix=$SCRIPT_DIR/rel-orig CFLAGS="-O3"
make -j$(nproc)
make install
make clean
$SCRIPT_DIR/gen_config.sh $SCRIPT_DIR/rel-orig/ config-appendix

git checkout 296a0ae5d
./buildconf
./configure --with-included-apr --prefix=$SCRIPT_DIR/rel-segfault CFLAGS="-O3"
make -j$(nproc)
make install
make clean
$SCRIPT_DIR/gen_config.sh $SCRIPT_DIR/rel-segfault/ config-appendix-segfault
