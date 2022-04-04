#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

function run {
	export PATH="$SCRIPT_DIR/../../../apps/leveldb/rel-$1/bin:$PATH"
	for i in {1..5}; do
		db_bench --benchmarks=fillseq --db=/tmp/testdb-orig --num=15000000 >> $1.log
		sleep 5
		pkill db_bench
	done
}

run orig
run orbit
