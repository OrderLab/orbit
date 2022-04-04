#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

sockfile=/tmp/mysql.sock

function mymysql {
    mysql -S ${sockfile} -u root "${@}"
}

mysqlargs="--mysql-socket=${sockfile} --mysql-user=root"

logdir=$PWD

taskfile=$SCRIPT_DIR/../../tools/sysbench/share/sysbench/oltp_read_write.lua

runtime=120

cd $taskdir

if [[ $1 == "" ]]; then
    echo 'Please specify experiment name'
    exit 1
fi
testname=$1

function find_mysqld {
    # We do not care about differences in multiple pgrep runs
    count=$(($(pgrep -x mysqld | wc -l)))
    if [[ $count != "1" ]]; then
        echo "Multiple mysqld instances found:" $(pgrep -x mysqld)
        exit 1
    fi
    mysqldpid=$(pgrep -x mysqld)
}

function find_mysqld_pidfile {
    mysqldpid=$(cat /tmp/mysqld.pid)
    if ps -p $mysqldpid > /dev/null; then
        :
    else
        echo "pid not found"
        exit 1
    fi
}

function sysbench_prepare {
    sysbench $taskfile $mysqlargs --threads=$1 --time=$runtime --report-interval=10 prepare
}

function sysbench_run {
    sysbench $taskfile $mysqlargs --threads=$1 --time=$runtime --report-interval=10 run
}

function sysbench_cleanup {
    sysbench $taskfile $mysqlargs cleanup
}

function run_once {
    thds=$1
    trial=$2
	echo what $thds

    sysbench_prepare $thds

    runname=sysbench-${testname}-${thds}-${trial}-$(date +%s)
    logfile=$logdir/sysbench-${testname}-${thds}.log
    cpulogfile=$logdir/sysbenchcpu-${testname}-${thds}.log
    dlckforklogfile=$logdir/sysbenchdlckfork-${testname}-${thds}.log

    echo $runname >> $logfile
    echo $runname >> $cpulogfile
    echo $runname >> $dlckforklogfile
    mymysql -e "SELECT NAME, COUNT FROM INFORMATION_SCHEMA.INNODB_METRICS WHERE NAME = 'lock_deadlock_checker_forks';" | tee -a $dlckforklogfile;

    ps -p $mysqldpid -o pid,comm,etime,time >> $cpulogfile
    cat /proc/$mysqldpid/stat >> $cpulogfile
    cat /proc/stat >> $cpulogfile
    # First half EOF
    echo 'EOF FIRST' >> $cpulogfile

    sysbench_run $thds | tee -a $logfile

    ps -p $mysqldpid -o pid,comm,etime,time >> $cpulogfile
    cat /proc/$mysqldpid/stat >> $cpulogfile
    cat /proc/stat >> $cpulogfile
    # First half EOF
    echo 'EOF SECOND' >> $cpulogfile

    mymysql -e "SELECT NAME, COUNT FROM INFORMATION_SCHEMA.INNODB_METRICS WHERE NAME = 'lock_deadlock_checker_forks';" | tee -a $dlckforklogfile;

    sysbench_cleanup
}

function run_all {
    #for thds in `seq 25 25 250`; do
    #for thds in 64; do
    #for thds in 4; do
    for thds in 16; do
        for t in 1; do
            run_once $thds $t
            sleep 10;
        done
    done
}

case $1 in
init)
    mymysql -e "create database sbtest;"
    ;;
prepare)
    sysbench_prepare
    ;;
run)
    sysbench_run
    ;;
cleanup)
    sysbench_cleanup
    ;;
*)
    # Otherwise, regard as experiment name
    find_mysqld_pidfile
    run_all
    ;;
esac
