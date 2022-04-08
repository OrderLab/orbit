#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

function ycsb {
    $SCRIPT_DIR/../../tools/ycsb/bin/ycsb $@
}

function run {
	tp=$1
	module load redis/$tp
	rm -f *.rdb

	#for i in {1..5}; do
	for i in 1; do
		rm -f *.rdb
		redis-server $SCRIPT_DIR/redis.conf &
		sleep 1

		ycsb load redis -s -P $SCRIPT_DIR/param > res-load-${tp}.out 2> res-load-${tp}.err
		sleep 5
		ycsb run redis -s -P $SCRIPT_DIR/param > res-run-${tp}-${i}.out 2> res-run-${tp}-${i}.err
		sleep 5

		killall redis-server
		sleep 1
		killall -9 redis-server
		sleep 1
	done
	module unload redis
}

run orig
run rdb
