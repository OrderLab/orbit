#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR/../

git clone git@github.com:OrderLab/orbit-compiler.git compiler
cd compiler
mkdir build
cd build
cmake ..
make -j$(nproc)
