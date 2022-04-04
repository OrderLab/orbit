#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

mkdir -p rel-plain/{include,lib} rel-dealloc/{include,lib}

git clone git@github.com:OrderLab/obiwan-userlib.git code
cd code
mkdir build
cd build

git checkout a6f7afb2
cmake ..
make -j$(nproc)
# TODO: install script within cmake
cp $PWD/../lib/include/orbit.h ../../rel-plain/include/
cp $PWD/lib/liborbit.so ../../rel-plain/lib/

git checkout c5770e9c
cmake ..
make -j$(nproc)
cp $PWD/../lib/include/orbit.h ../../rel-dealloc/include/
cp $PWD/lib/liborbit.so ../../rel-dealloc/lib/
