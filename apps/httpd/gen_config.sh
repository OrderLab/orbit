#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

if [[ "x$1" == 'x' ]]; then
	echo "Need first argument as HTTPD install root"
	exit 1;
fi
root=$1

if [[ "x$2" == 'x' ]]; then
	echo "Need second argument as appendix path"
	exit 1;
fi
appendix=$2

origpath=$root/conf/original/httpd.conf
targetpath=$root/conf/httpd.conf

if [ ! -f $origpath ]; then
	echo "Cannot find original httpd.conf file at path" $origpath
	exit 1
fi

cat $origpath \
	| sed 's/^Listen 80$/Listen 8080/' \
	| sed 's/^#LoadModule proxy_module/LoadModule proxy_module/' \
	| sed 's/^#LoadModule proxy_http_module/LoadModule proxy_http_module/' \
	| sed 's/^#LoadModule proxy_balancer_module/LoadModule proxy_balancer_module/' \
	| sed 's/^#LoadModule slotmem_shm_module/LoadModule slotmem_shm_module/' \
	| sed 's/^#LoadModule lbmethod_byrequests_module/LoadModule lbmethod_byrequests_module/' \
	| sed 's/^User daemon/#User daemon/' \
	| sed 's/^Group daemon/#Group daemon/' \
	| sed 's/^#ServerName www.example.com:80/ServerName localhost:8080/' \
	> $targetpath

cat $appendix >> $targetpath
