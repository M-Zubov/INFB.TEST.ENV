#!/bin/bash

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"

if [ -z "$TEST_PLAN_PATH" ] ; then TEST_PLAN_PATH=$SCRIPT_DIR/jmx/test-static.jmx ; fi
if [ -z "$THREAD_COUNT" ] ; then THREAD_COUNT=1 ; fi
if [ -z $LOOP_COUNT ] ; then LOOP_COUNT=1 ; fi
if [ -z $SERVER_PORT ] ; then SERVER_PORT=80 ; fi
if [ -z "$SERVER_PATH" ] ; then SERVER_PATH="/" ; fi
if [ -z "$LOG_NAME" ] ; then LOG_NAME="test-999" ; fi
if [ -z $RUN_REMOTE ] ; then RUN_REMOTE=false ; fi
if [ -z "$RESULT_DIR" ] ; then RESULT_DIR="./results" ; fi

if [ ! -d "$RESULT_DIR" ]
then
    mkdir -p "$RESULT_DIR"
fi

if [ "true" == "$RUN_REMOTE" ]
then
    RUN_COMMAND_REMOTE=" -R jmeter-node-1,jmeter-node-2,jmeter-node-3"
    DEF=G
    NROF_TEST_NODES=3
else
    RUN_COMMAND_REMOTE=""
    DEF=D
    NROF_TEST_NODES=1
fi

LOG_FILE_NAME_BASE=${RESULT_DIR}/${LOG_NAME}
LOG_FILE_NAME_BASE+=-t$(( ${NROF_TEST_NODES} * ${THREAD_COUNT} ))
LOG_FILE_NAME_BASE+=-l${LOOP_COUNT}

# clean-up files from previous runs because *.jtl files are appended.
rm -f "${LOG_FILE_NAME_BASE}.*"

RUN_COMMAND="$SCRIPT_DIR/../bin/jmeter.sh -n -t ${TEST_PLAN_PATH}"
RUN_COMMAND+=$RUN_COMMAND_REMOTE
RUN_COMMAND+=" -j ${LOG_FILE_NAME_BASE}.log"
RUN_COMMAND+=" -l ${LOG_FILE_NAME_BASE}.jtl"
RUN_COMMAND+=" -${DEF}threadCount=${THREAD_COUNT}"
RUN_COMMAND+=" -${DEF}loopCount=${LOOP_COUNT}"
RUN_COMMAND+=" -${DEF}serverPort=${SERVER_PORT}"
RUN_COMMAND+=" -${DEF}path=${SERVER_PATH}"
RUN_COMMAND+=" -${DEF}jmeter.save.saveservice.output_format=csv"
RUN_COMMAND+=" -${DEF}jmeter.save.saveservice.print_field_names=true"

echo "Running command: ${RUN_COMMAND}"
/usr/bin/time -v ${RUN_COMMAND} 2>&1 | tee "${LOG_FILE_NAME_BASE}.out"

exit ${PIPESTATUS[0]}

# end of file
