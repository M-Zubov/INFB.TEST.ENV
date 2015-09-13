#!/bin/bash

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"
if [ -z "$RESULT_DIR" ] ; then RESULT_DIR="./results" ; fi

pushd $RESULT_DIR

TEMPLATES=`ls *.out | sed 's/\-t[0-9][0-9]*/\-\\\*/g' | sort | uniq`
echo "[DEBUG] TEMPLATES = $TEMPLATES"
for CUR_TEMPLATE in $TEMPLATES
do
    echo "[DEBUG] CUR_TEMPLATE = $CUR_TEMPLATE"
    OUT_FILE=`echo $CUR_TEMPLATE | sed 's/\-\\\\\*//g' | sed 's/\.out$/\.csv/'`
    echo "[DEBUG] OUT_FILE = $OUT_FILE"
    echo "The Number of Threads,Response Time MIN (ms),Response Time AVG (ms),Response Time MAX (ms),The number of Errors,JMeter Memory Consumption AVG (kb),JMeter Memory Consumption MAX (kb)" > $OUT_FILE
    CUR_TEMPLATE=`echo $CUR_TEMPLATE | sed 's/\-\\\\\*/\-\*/g'`
    echo "[DEBUG] CUR_TEMPLATE = $CUR_TEMPLATE"
    for i in `ls $CUR_TEMPLATE`
    do
        NROF_THREADS=`echo "$i" | grep -o -P "\-t\d+\-" | grep -o -P "\d+"`
        echo "[DEBUG] NROF_THREADS = $NROF_THREADS"
        RESPONSE_TIME_MAX=`grep "summary = " $i | tail -n1 | grep -o -P "Max:\s+\d+" | grep -o -P "\d+"`
        RESPONSE_TIME_MIN=`grep "summary = " $i | tail -n1 | grep -o -P "Min:\s+\d+" | grep -o -P "\d+"`
        RESPONSE_TIME_AVG=`grep "summary = " $i | tail -n1 | grep -o -P "Avg:\s+\d+" | grep -o -P "\d+"`
        NROF_ERRORS=`grep "summary = " $i | tail -n1 | grep -o -P "Err:\s+\d+" | grep -o -P "\d+"`
        JMETER_MEMORY_MAX=`grep "Maximum resident set size (kbytes):" $i | grep -o -P "\d+"`
        JMETER_MEMORY_AVG=`grep "Average resident set size (kbytes):" $i | grep -o -P "\d+"`
        echo "${NROF_THREADS},${RESPONSE_TIME_MIN},${RESPONSE_TIME_AVG},${RESPONSE_TIME_MAX},${NROF_ERRORS},${JMETER_MEMORY_AVG},${JMETER_MEMORY_MAX}" >> $OUT_FILE
    done
done

popd

#end of file
