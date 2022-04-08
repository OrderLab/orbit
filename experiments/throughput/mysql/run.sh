#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

# sysbench
export PATH="$SCRIPT_DIR/../../tools/sysbench/bin/sysbench:$PATH"

function run {
	module load mysql/$1
	mysqld --user=root &
	sleep 3

	./sysbench.sh init
	./sysbench.sh cleanup
	./sysbench.sh $1
	./sysbench.sh cleanup

	killall -9 mysqld
	sleep 1
	module unload mysql
}

run orig
run orbit
