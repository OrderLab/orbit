#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR/../

echo "Please also run:"
echo "    echo 'export MODULEPATH=$(pwd)/modulefiles' >> ~/.bashrc"
echo "to setup the MODULEPATH environment."

newroot=$(pwd | sed 's/\//\\\//g')

for d in `ls modulefiles`; do
	for f in `ls modulefiles/$d`; do
		sed "s/\/root\/orbit/${newroot}/" -i modulefiles/$d/$f;
	done
done
