#!/bin/bash

repeat=1
if [ ! -z "$1" ]; then
	repeat=$1
fi

function run_once {
    mysqld --user=root &
    mysqlpid=$!
    sleep 3

    ../incone.sh $1 $2 $3 $mysqlpid

    sleep 1
    killall mysql
    sleep 5

    killall mysqld
    sleep 1
    killall -9 mysqld
    sleep 1
}

function run_all {
    name=$1
    echo Running $name ...
    module load mysql/$name

    for thds in 16; do
        for t in `seq $repeat`; do
            run_once $name $thds $t
        done
    done

    module unload mysql
}

run_all orbit
run_all sync
