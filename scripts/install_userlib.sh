#!/bin/bash

git clone git@github.com:OrderLab/obiwan-userlib.git userlib

cd userlib
git checkout a6f7afb2
mkdir build
cd build
cmake ..
make -j$(nproc)
# TODO: install script within cmake
cd ..
ln -sf $PWD/lib/include/orbit.h /usr/include/orbit.h
ln -sf $PWD/build/lib/liborbit.so /usr/lib/liborbit.so
