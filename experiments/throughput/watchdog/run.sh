#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

function ab {
    $SCRIPT_DIR/../../apps/httpd/rel-orig/bin/ab $@
}

duration=120

url=http://127.0.0.1:8080/somepath/

thd=4

function run {
	export PATH="$SCRIPT_DIR/../../apps/httpd/rel-$1/bin:$PATH"
	apachectl -X -k start &
	pid=$!
	for i in {1..5}; do
		ab -c$thd -t$duration -n100000000 $url > res-${1}${thd}-${i}.out
		sleep 5
	done
	apachectl -X -k stop
}

run orig
run watchdog
