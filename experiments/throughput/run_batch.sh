#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

repeat=1
re='^[0-9]+$'
if [[ $1 =~ $re ]] ; then
	repeat=$1
fi
echo Will repeat for $repeat times

for f in ${@}; do
	if [ ! -d "$f" ]; then
		echo Experiment "\"$f\"" not found!
		continue
	fi
	echo Running experiment "\"$f\""...
	./$f/run.sh $repeat
done
