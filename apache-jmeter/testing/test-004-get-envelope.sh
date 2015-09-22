#!/bin/bash

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"

# get id of a previously uploaded file
FILE_ID=`cat $SCRIPT_DIR/.uploaded-file-id.txt`

TEST_PLAN_PATH=$SCRIPT_DIR/jmx/test-static.jmx \
SERVER_PORT=9080 \
SERVER_PATH="/cloudStorage$NODE/v1.0/DICOMEnvelope?id=$FILE_ID" \
LOG_NAME="test-004-get-envelope$NODE" \
$SCRIPT_DIR/_run-single-test.sh

#end of file
