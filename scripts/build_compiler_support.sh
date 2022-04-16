#!/bin/bash
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR/../

git submodule update --init --remote compiler
cd compiler
mkdir build
cd build
cmake ..
make -j$(nproc)
