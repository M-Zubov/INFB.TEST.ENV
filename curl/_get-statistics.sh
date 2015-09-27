#!/bin/bash

# parse logs from _run-single-download-test*.sh runs
# and print statistics in the apache jmeter format

if [ -z "$TEST_DURATION" ] ; then
    echo "ERROR: the 'TEST_DURATION' variable was not specified"
    exit 1
fi
if [ -z "$CURR_RESULT_DIR" ] ; then
    echo "ERROR: the 'CURR_RESULT_DIR' variable was not specified"
    exit 1
fi

successCountTotal=0
errorCountTotal=0
timeSumTotal=0
timeMinTotal=999999
timeMaxTotal=0
reqCountTotal=0
for currFile in `ls ${CURR_RESULT_DIR}/*-node.log`
do
    dataLine=`grep "summary = " $currFile`
	echo ${dataLine/summary =/summary +}

	numReqs=`echo "$dataLine" | cut -f1 | cut -d" " -f3`
	timeSum=`echo "$dataLine" | cut -f2 | cut -d" " -f2`
	timeSum=${timeSum/s/}
	timeMin=`echo "$dataLine" | cut -f5 | cut -d" " -f2`
	timeMax=`echo "$dataLine" | cut -f6 | cut -d" " -f2`
	errorCount=`echo "$dataLine" | cut -f7 | cut -d" " -f2`
	successCount=$(( ${numReqs} - ${errorCount} ))
	reqCountTotal=$(( ${reqCountTotal} + ${numReqs} ))

    errorCountTotal=$(( ${errorCountTotal} + ${errorCount} ))
    successCountTotal=$(( ${successCountTotal} + ${successCount} ))
    timeSumTotal=`echo "${timeSumTotal} + ${timeSum}" | bc -l`
    if (( $(echo "${timeMin} < ${timeMinTotal}" | bc -l ) ))
    then
        timeMinTotal=$timeMin
    fi
    if (( $(echo "${timeMax} > ${timeMaxTotal}" | bc -l ) ))
    then
        timeMaxTotal=$timeMax
    fi
done
reqPerSec=`echo "scale=3; ${reqCountTotal} / ${TEST_DURATION}" | bc -l`
errorPercentage=`echo "scale=3; ${errorCountTotal} / ${reqCountTotal} * 100" | bc -l`
timeAvg=`echo "scale=3; ${timeSumTotal} / ${successCountTotal}" | bc -l`
echo -e "summary = ${reqCountTotal}\tin ${timeSumTotal}s\t= ${reqPerSec}/s\tAvg: ${timeAvg}\tMin: ${timeMinTotal}\tMax: ${timeMaxTotal}\tErr: ${errorCountTotal} (${errorPercentage}%)"

# end of file
