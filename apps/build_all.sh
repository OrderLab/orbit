#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

for f in httpd leveldb nginx redis varnish mysql; do
	$f/build.sh
done
