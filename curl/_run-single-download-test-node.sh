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
if [ -z "$REF_FILE_PATH" ] ; then REF_FILE_PATH="${SCRIPT_DIR}/../data/000000.dcm" ; fi

CURR_RESULT_DIR=${RESULT_DIR}/${LOG_NAME}
CURR_RESULT_DIR+=-t${THREAD_COUNT}
CURR_RESULT_DIR+=-l${LOOP_COUNT}

if [ -e "$CURR_RESULT_DIR" ]
then
    rm -fr "$CURR_RESULT_DIR"
fi
mkdir -p "$CURR_RESULT_DIR"

timeStart=`date +%s`
for i in `seq 1 $THREAD_COUNT`
do
    THREAD_NUM=$i \
    LOOP_COUNT=$LOOP_COUNT \
    SERVER_PORT=$SERVER_PORT \
    SERVER_PATH=$SERVER_PATH \
    CURR_RESULT_DIR=$CURR_RESULT_DIR \
    REF_FILE_PATH=$REF_FILE_PATH \
    ${SCRIPT_DIR}/_run-single-download-test-thread.sh &
done
wait
timeEnd=`date +%s`
timeDuration=$(( ${timeEnd} - ${timeStart} ))

CURR_RESULT_DIR=$CURR_RESULT_DIR \
THREAD_COUNT=$THREAD_COUNT \
LOOP_COUNT=$LOOP_COUNT \
TEST_DURATION=$timeDuration \
${SCRIPT_DIR}/_get-statistics-node.sh

# end of file
