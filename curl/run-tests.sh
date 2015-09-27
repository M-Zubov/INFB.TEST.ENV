#!/bin/bash

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"

export RESULT_DIR=${SCRIPT_DIR}/results/`date +%Y-%m-%d-%H-%M-%S`
export RUN_REMOTE=true

pushd $SCRIPT_DIR

#======================================================================

for i in 10 100
do
   THREAD_COUNT=$i LOOP_COUNT=30 ./test-001-http-big.sh || exit 1
done

#======================================================================

for i in 10 100
do
   THREAD_COUNT=$i LOOP_COUNT=300 ./test-002-client.sh || exit 2
done

#======================================================================

popd

#======================================================================
# end of file

