#!/bin/bash

# this file is used to run a test in a single thread
# this script should be executed stand-alone, but
# should be executed from the _run-single-download-test.sh

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"

if [ -z $SERVER_PORT ] ; then 
    echo "ERROR: the 'SERVER_PORT' variable was not specified"
    exit 1
fi
if [ -z "$SERVER_PATH" ] ; then
    echo "ERROR: the 'SERVER_PATH' variable was not specified"
    exit 1
fi
if [ -z "$THREAD_NUM" ] ; then
     echo "ERROR: the 'THREAD_NUM' variable was not specified"
     exit 1
fi
if [ -z "$LOOP_COUNT" ] ; then
    echo "ERROR: the 'LOOP_COUNT' variable was not specified"
    exit 1
fi
if [ -z "$CURR_RESULT_DIR" ] ; then
    echo "ERROR: the 'CURR_RESULT_DIR' variable was not specified"
    exit 1
fi
if [ -z "$REF_FILE_PATH" ] ; then
    echo "ERROR: the 'REF_FILE_PATH' variable was not specified"
    exit 1
fi

LOG_FILE_NAME=${CURR_RESULT_DIR}/tn${THREAD_NUM}.out
# clean-up files from previous runs because files are appended.
rm -f "${LOG_FILE_NAME}"

LOCAL_FILE_NAME=000000-${THREAD_NUM}.dcm
rm -f $LOCAL_FILE_NAME

for i in `seq 1 $LOOP_COUNT`
do
    timeVal=`curl http://10.16.0.2:${SERVER_PORT}${SERVER_PATH} -o $LOCAL_FILE_NAME -w "%{time_total}\n" -s`
	fileDiff=`diff -q $REF_FILE_PATH $LOCAL_FILE_NAME`
    if [ -z "$fileDiff" ]
    then
        echo "$timeVal" >> ${LOG_FILE_NAME}
    else
        echo "ERROR" >> ${LOG_FILE_NAME}
    fi
    rm $LOCAL_FILE_NAME
done

echo "Thread ${THREAD_NUM} finished."

# end of file
