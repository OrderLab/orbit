#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

mkdir -p ycsb

git clone https://github.com/brianfrankcooper/YCSB.git ycsb-code
cd ycsb-code
git checkout ce3eb9ce51c84ee9e236998cdd2cefaeb96798a8
git apply ../ycsb-customize.patch

mvn -pl site.ycsb:redis-binding -am clean package
tar -xf redis/target/ycsb-redis-binding-*.tar.gz \
	-C $SCRIPT_DIR/ycsb/ --strip-components=1
