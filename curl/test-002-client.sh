#!/bin/bash

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"

SERVER_PORT=8080 \
SERVER_PATH="/cloudStorage/images/000000.dcm" \
LOG_NAME="test-002-client" \
REF_FILE_PATH="${SCRIPT_DIR}/../data/000000.dcm" \
$SCRIPT_DIR/_run-single-test.sh

#end of file
