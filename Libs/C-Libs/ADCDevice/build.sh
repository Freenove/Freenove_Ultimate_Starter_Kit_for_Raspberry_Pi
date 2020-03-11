#!/bin/sh

current_file=$0
cd "$(dirname "$current_file")"

g++ -c ADCDevice.cpp
g++ -shared -fPIC -o libADCDevice.so ADCDevice.o
sudo cp ADCDevice.hpp /usr/include/
sudo cp libADCDevice.so /usr/lib
sudo ldconfig

echo "build completed!"
