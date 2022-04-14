#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

module load userlib/plain
make

limit=$((1024 * 1024 * 1024))

echo 'Size,Time(ns)' > orbit-snap.csv

for ((size=4096; $size <= $limit; size=$((2 * $size)))); do
	echo $size
	for i in {1..20}; do
		./snap $size >> orbit-snap.csv
		sleep 0.01
	done
done
