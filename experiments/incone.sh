#!/bin/bash

# Increment by one
# https://dom.as/2009/12/21/on-deadlock-detection/
# https://bugs.mysql.com/bug.php?id=49047

if [[ $1 == "" ]]; then
    echo 'Please specify experiment name'
    exit 1
fi
testname=$1

sockfile=/tmp/mysql.sock

function mymysql {
    mysql -S ${sockfile} -u root "${@}"
}

function run_once {
    thds=$1
    trial=$2

    runname=incone-${testname}-${thds}-${trial}-$(date +%s)
    logfile=incone-${testname}-${thds}.log
    cpulogfile=inconecpu-${testname}-${thds}.log
    reportfile=incone-${testname}-${thds}-report-${trial}.log
    # those are append
    echo $runname >> $logfile
    echo $runname >> $cpulogfile
    # this will overwrite
    echo $runname > $reportfile

    mymysql -e "SELECT NAME, COUNT FROM INFORMATION_SCHEMA.INNODB_METRICS WHERE NAME = 'lock_deadlock_checker_forks';" | tee -a $logfile

    ps -p $mysqldpid -o pid,comm,etime,time >> $cpulogfile
    cat /proc/$mysqldpid/stat >> $cpulogfile
    cat /proc/stat | grep '^cpu ' >> $cpulogfile
    # First half EOF
    echo 'EOF FIRST' >> $cpulogfile

    mymysql play -e "UPDATE t1 SET a = 0"
    for i in `seq $thds`; do ( yes "UPDATE t1 SET a=a+1;" | mymysql play & ) ; done
    for i in {1..60}; do
        sleep 2
        mymysql --skip-column-names -e "select a from play.t1" >> $reportfile
    done
    killall mysql

    ps -p $mysqldpid -o pid,comm,etime,time >> $cpulogfile
    cat /proc/$mysqldpid/stat >> $cpulogfile
    cat /proc/stat | grep '^cpu ' >> $cpulogfile
    # First half EOF
    echo 'EOF SECOND' >> $cpulogfile

    sleep 5

    mymysql -e "select a, a/120 AS per_sec from play.t1" | tee -a $logfile
    mymysql -e "SELECT NAME, COUNT FROM INFORMATION_SCHEMA.INNODB_METRICS WHERE NAME = 'lock_deadlock_checker_forks';" | tee -a $logfile
}

mymysql -e "CREATE DATABASE IF NOT EXISTS play; DROP TABLE IF EXISTS play.t1; CREATE TABLE play.t1 (a int); INSERT INTO play.t1 VALUES (5);"

mysqldpid=$4
run_once $2 $3
