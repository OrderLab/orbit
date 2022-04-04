#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

gcc mix.c -o mix -lcurl -O3

duration=120

thd=4

function run {
	module load httpd/$1
	apachectl -X -k start &
	pid=$!
	for i in {1..5}; do
		./mix > $1-1.log &
		pid1=$!
		./mix > $1-2.log &
		pid2=$!
		./mix > $1-3.log &
		pid3=$!
		./mix > $1-4.log &
		pid4=$!
		wait $pid1
		wait $pid2
		wait $pid3
		wait $pid4
	done
	apachectl -X -k stop
	module unload httpd
	sleep 1
}

run orig
run proxy
