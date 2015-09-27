#!/bin/bash

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"

SERVER_PORT=80 \
SERVER_PATH="/000000.html" \
LOG_NAME="test-001-http-big" \
REF_FILE_PATH="${SCRIPT_DIR}/../data/000000.dcm" \
$SCRIPT_DIR/_run-single-download-test.sh

#end of file
