#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

repeat=1
if [ ! -z "$1" ]; then
	repeat=$1
fi

function ab {
    $SCRIPT_DIR/../../../apps/httpd/rel-orig/bin/ab $@
}

duration=120

url=http://127.0.0.1:8080/somepath/

thd=4

# Regenerate configs
cd ../../../apps/httpd
./gen_config.sh $PWD/rel-watchdog/ $PWD/config-appendix
./gen_config.sh $PWD/rel-orig/ $PWD/config-appendix
cd $SCRIPT_DIR

function run {
	systemctl start nginx
	sleep 1

	module load httpd/$1
	apachectl -X -k start &
	sleep 1

	for i in `seq $repeat`; do
		ab -c$thd -t$duration -n100000000 $url > res-${1}${thd}-${i}.out
		sleep 5
	done
	apachectl -X -k stop
	sleep 1
	killall -9 httpd
	module unload httpd
	sleep 1

	systemctl stop nginx
	sleep 1
}

run orig
run watchdog
