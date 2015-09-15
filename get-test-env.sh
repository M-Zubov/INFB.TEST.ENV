#!/bin/bash

# get testing environment to a local folder

if [ -e testing ]
then
    rm -fr testing
fi

git clone https://github.com/M-Zubov/INFB.TEST.ENV.git testing

# end of file
