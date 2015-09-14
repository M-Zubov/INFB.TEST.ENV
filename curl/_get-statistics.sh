#!/bin/bash

# parse logs from _run-single-download-test*.sh runs
# and print statistics in the apache jmeter format

if [ -z "$CURR_RESULT_DIR" ] ; then
    echo "ERROR: the 'CURR_RESULT_DIR' variable was not specified"
    exit 1
fi
if [ -z "$LOOP_COUNT" ] ; then
    echo "ERROR: the 'LOOP_COUNT' variable was not specified"
    exit 1
fi
if [ -z "$THREAD_COUNT" ] ; then
    echo "ERROR: the 'THREAD_COUNT' variable was not specified"
    exit 1
fi

successCountTotal=0
errorCountTotal=0
timeSumTotal=0
timeMinTotal=999999
timeMaxTotal=0
for currFile in `ls ${CURR_RESULT_DIR}/*`
do
    errorCount=0
    successCount=0
    timeSum=0
    for line in `cat $currFile`
    do
        if [ -z `echo "$line" | grep -i ERROR` ]
        then
            successCount=$(( ${successCount} + 1 ))
            timeSum=`echo "${timeSum} + ${line}" | bc -l`
        else
            errorCount=$(( ${errorCount} + 1 ))
        fi
    done
    errorCountTotal=$(( ${errorCountTotal} + ${errorCount} ))
    successCountTotal=$(( ${successCountTotal} + ${successCount} ))
    timeSumTotal=`echo "${timeSumTotal} + ${timeSum}" | bc -l`
    timeMin=`grep -v ERROR ${currFile} | sort -g | head -n1`
    timeMax=`grep -v ERROR ${currFile} | sort -g | tail -n1`
    timeAvg=`echo "scale=3; ${timeSum} / ${successCount}" | bc -l`
    if (( $(echo "${timeMin} < ${timeMinTotal}" | bc -l ) ))
    then
        timeMinTotal=$timeMin
    fi
    if (( $(echo "${timeMax} > ${timeMaxTotal}" | bc -l ) ))
    then
        timeMaxTotal=$timeMax
    fi
    errorPercentage=`echo "scale=3; ${errorCount} / ${LOOP_COUNT} * 100" | bc -l`
    reqPerSec=`echo "scale=3; ${LOOP_COUNT} / ${timeSum}" | bc -l`
    echo -e "summary + ${LOOP_COUNT}\tin ${timeSum}s\t= ${reqPerSec}/s\tAvg: ${timeAvg}\tMin: ${timeMin}\tMax: ${timeMax}\tErr: ${errorCount} (${errorPercentage}%)"
done
reqCount=$(( ${LOOP_COUNT} * ${THREAD_COUNT} ))
reqPerSec=`echo "scale=3; ${reqCount} / ${timeSumTotal}" | bc -l`
errorPercentage=`echo "scale=3; ${errorCountTotal} / ${reqCount} * 100" | bc -l`
timeAvg=`echo "scale=3; ${timeSumTotal} / ${successCountTotal}" | bc -l`
echo -e "summary = ${reqCount}\tin ${timeSumTotal}s\t= ${reqPerSec}/s\tAvg: ${timeAvg}\tMin: ${timeMinTotal}\tMax: ${timeMaxTotal}\tErr: ${errorCountTotal} (${errorPercentage}%)"

# end of file
