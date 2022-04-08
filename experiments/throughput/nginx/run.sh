#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

make

duration=120

thd=4

function run {
	systemctl stop nginx
	sleep 1

	module load nginx/$1
	nginx
	sleep 1

	#for i in {1..5}; do
	for i in 1; do
		./mix > $1-$i.log
		sleep 1
	done

	nginx -s stop
	sleep 1
	pkill -9 nginx
	module unload nginx
	sleep 1
}

run orig
run orbit
