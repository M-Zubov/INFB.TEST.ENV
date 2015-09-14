#!/bin/bash

# download a file from location specified in a SERVER_PORT and SERVER_PATH
# variables.
# downloading the file in a several threads simultaneously

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"

if [ -z "$SERVER_PORT" ] ; then SERVER_PORT=80 ; fi
if [ -z "$SERVER_PATH" ] ; then SERVER_PATH="/000000.html" ; fi
if [ -z "$THREAD_COUNT" ] ; then THREAD_COUNT=1 ; fi
if [ -z "$LOOP_COUNT" ] ; then LOOP_COUNT=1 ; fi
if [ -z "$LOG_NAME" ] ; then LOG_NAME="test-999" ; fi
if [ -z "$RESULT_DIR" ] ; then RESULT_DIR="./results" ; fi
if [ -z "$LOG_NAME" ] ; then LOG_NAME="test-999" ; fi
if [ -z "$MD5SUM" ] ; then MD5SUM="f5cb3755db2ccc1a740b266d91c73631" ; fi

CURR_RESULT_DIR=${RESULT_DIR}/${LOG_NAME}
CURR_RESULT_DIR+=-t${THREAD_COUNT}
CURR_RESULT_DIR+=-l${LOOP_COUNT}

if [ -e "$CURR_RESULT_DIR" ]
then
    rm -fr "$CURR_RESULT_DIR"
fi
mkdir -p "$CURR_RESULT_DIR"

for i in `seq 1 $THREAD_COUNT`
do
    THREAD_NUM=$i \
    LOOP_COUNT=$LOOP_COUNT \
    SERVER_PORT=$SERVER_PORT \
    SERVER_PATH=$SERVER_PATH \
    CURR_RESULT_DIR=$CURR_RESULT_DIR \
    MD5SUM=$MD5SUM \
    ${SCRIPT_DIR}/_run-single-download-test-thread.sh &
done
wait

CURR_RESULT_DIR=$CURR_RESULT_DIR \
THREAD_COUNT=$THREAD_COUNT \
LOOP_COUNT=$LOOP_COUNT \
${SCRIPT_DIR}/_get-statistics.sh

# end of file
