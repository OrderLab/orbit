#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

make

duration=120

thd=4

# Regenerate configs
cd ../../../apps/httpd
./gen_config.sh $PWD/rel-proxy/ $PWD/config-appendix
./gen_config.sh $PWD/rel-orig/ $PWD/config-appendix
cd $SCRIPT_DIR

function run {
	systemctl start nginx
	sleep 1

	module load httpd/$1
	apachectl -k start
	sleep 1

	#for i in {1..5}; do
	for i in 1; do
		./mix > $1-$i.log
		sleep 1
	done

	apachectl -k stop
	module unload httpd
	sleep 1
	pkill -9 httpd

	systemctl stop nginx
	sleep 1
}

run orig
run proxy
