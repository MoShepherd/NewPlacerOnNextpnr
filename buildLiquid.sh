#!/bin/bash

#set -e

sudo cmake -B build \
  -DCMAKE_BUILD_TYPE=Debug \
  -DARCH=himbaechel \
  -DHIMBAECHEL_UARCH=gatemate \
  -DHIMBAECHEL_PEPPERCORN_PATH=/mnt/c/Users/morit/Studium/Master/Forschungsprojekt/prjpeppercorn \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DEXTERNAL_CHIPDB=ON

sudo make -j$(nproc)

sudo make install