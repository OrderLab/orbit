#!/bin/bash

git clone git@github.com:OrderLab/obiwan-mysql.git code

cd rel-orig; ./build.sh; cd ..
cd rel-orbit; ./build.sh; cd ..
