#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

function ab {
    $SCRIPT_DIR/../../../apps/httpd/rel-orig/bin/ab $@
}

duration=120

url=http://127.0.0.1:8080/

thd=4

function run {
	systemctl start nginx
	sleep 1

	module load varnish/$1
	varnishd -a :8080 -f $SCRIPT_DIR/config.vcl -p thread_pools=1 -p thread_pool_min=2 -p thread_pool_max=20 -p thread_pool_timeout=10
	sleep 1

	#for i in {1..5}; do
	for i in 1; do
		ab -c$thd -t$duration -n100000000 $url > res-${1}${thd}-${i}.out
		sleep 5
	done

	varnishadm stop
	sleep 1
	module unload varnish

	systemctl stop nginx
	sleep 1
}

run orig
run orbit
