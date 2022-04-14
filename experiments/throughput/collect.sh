#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

function avg {
	# with empty value protection
	python3 -c 'import sys; from statistics import mean; print(mean([eval(v.strip()) for v in sys.stdin.readlines() if len(v.strip()) != 0] or [0]))'
}

function collect_t1 {
	cd mysql
	orbit=$(grep -F queries: sysbench-orbit-16-*.log | awk '{print substr($3,2)}' | avg)
	orig=$(grep -F queries: sysbench-orig-16-*.log | awk '{print substr($3,2)}' | avg)
	echo "t1,MySQL deadlock detector,$orbit,$orig"
	cd ..
}

function collect_t2 {
	cd proxy
	# `mix` outputs time. Since we only look at the relative performance, we intentionally
	# exchange the variable of following to lines.
	orig=$(cat proxy-*.log | avg)
	orbit=$(cat orig-*.log | avg)
	echo "t2,Apache proxy balancer,$orbit,$orig"
	cd ..
}

function collect_t3 {
	cd watchdog
	orbit=$(grep -F 'Requests per second:' res-watchdog4-*.out | awk '{print $4}' | avg)
	orig=$(grep -F 'Requests per second:' res-orig4-*.out | awk '{print $4}' | avg)
	echo "t3,Apache watchdog,$orbit,$orig"
	cd ..
}

function collect_t4 {
	cd nginx
	# `mix` outputs time. Since we only look at the relative performance, we intentionally
	# exchange the variable of following to lines.
	orig=$(cat orbit-*.log | avg)
	orbit=$(cat orig-*.log | avg)
	echo "t4,Nginx WebDAV handler,$orbit,$orig"
	cd ..
}

function collect_t5 {
	cd varnish
	orbit=$(grep -F 'Requests per second:' res-orbit4-*.out | awk '{print $4}' | avg)
	orig=$(grep -F 'Requests per second:' res-orig4-*.out | awk '{print $4}' | avg)
	echo "t5,Varnish pool herder,$orbit,$orig"
	cd ..
}

function collect_t6 {
	cd slowlog
	orbit=$(grep -F '[OVERALL], Throughput(ops/sec)' res-run-slowlog-*.out | awk '{print $3}' | avg)
	orig=$(grep -F '[OVERALL], Throughput(ops/sec)' res-run-orig-*.out | awk '{print $3}' | avg)
	echo "t6,Redis slowlog,$orbit,$orig"
	cd ..
}

function collect_t7 {
	cd rdb
	orbit=$(grep -F '[OVERALL], Throughput(ops/sec)' res-run-rdb-*.out | awk '{print $3}' | avg)
	orig=$(grep -F '[OVERALL], Throughput(ops/sec)' res-run-orig-*.out | awk '{print $3}' | avg)
	echo "t7,Redis RDB,$orbit,$orig"
	cd ..
}

function collect_t8 {
	cd leveldb
	orbit=$(grep fillseq orbit-*.log | awk '{print $5}' | avg)
	orig=$(grep fillseq orig-*.log | awk '{print $5}' | avg)
	echo "t8,LevelDB compaction,$orbit,$orig" 
	cd ..
}

function collect {
	echo "Case,Name,Orbit,Vanilla"
	for i in {1..8}; do
		collect_t$i
	done
}

collect > overhead.csv
