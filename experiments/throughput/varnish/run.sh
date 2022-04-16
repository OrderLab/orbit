#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

repeat=1
re='^[0-9]+$'
if [[ $1 =~ $re ]] ; then
	repeat=$1
elif [[ $1 == '-n' ]]; then
	if [[ $2 =~ $re ]]; then
		fileid=$2
	else
		echo "Invalid -n argument. Expected a number."
		exit 1
	fi
fi

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

	for i in `seq $repeat`; do
		if [ ! -z "$fileid" ]; then
			i=$fileid
		fi

		ab -c$thd -t$duration -n100000000 $url > res-${1}${thd}-${i}.out
		sleep 5
	done

	varnishadm stop
	sleep 1
	pkill -9 varnishd
	sleep 1
	module unload varnish

	systemctl stop nginx
	sleep 1
}

run orig
run orbit
