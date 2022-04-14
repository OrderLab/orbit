#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

repeat=1
if [ ! -z "$1" ]; then
	repeat=$1
fi

function run {
	module load leveldb/$1
	rm -rf /tmp/obtestdb
	for i in `seq $repeat`; do
		db_bench --benchmarks=fillseq --db=/tmp/obtestdb --num=15000000 > $1-$i.log
		sleep 5
		pkill -9 db_bench
		sleep 1
		rm -rf /tmp/obtestdb
	done
	module unload leveldb
}

run orig
run orbit
