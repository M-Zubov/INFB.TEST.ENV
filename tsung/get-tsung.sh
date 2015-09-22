#!/bin/bash

FILE_NAME=tsung-1.6.0.tar.gz
FILE_PATH=http://tsung.erlang-projects.org/dist

sudo apt-get update
sudo apt-get install -y make
sudo apt-get install -y erlang
wget ${FILE_PATH}/${FILE_NAME}
wget ${FILE_PATH}/${FILE_NAME}.sha256
sha256sum --check ${FILE_NAME}.sha256

if [ 0 -ne $? ]
then
    echo "ERROR: the ${FILE_NAME} file was downloaded incorrectly"
    exit 1
fi

tar xf ${FILE_NAME}
pushd ${FILE_NAME%.tar.gz}
./configure
make
sudo make install
popd

which tsung
tsung -version

# end of file
