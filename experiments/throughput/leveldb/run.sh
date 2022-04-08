#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

function run {
	module load leveldb/$1
	#for i in {1..5}; do
	for i in 1; do
		db_bench --benchmarks=fillseq --db=/tmp/testdb --num=15000000 >> $1.log
		sleep 5
		pkill -9 db_bench
		sleep 1
		rm -rf /tmp/testdb
	done
	module unload leveldb
}

run orig
run orbit
