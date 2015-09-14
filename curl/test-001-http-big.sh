#!/bin/bash

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"

SERVER_PORT=80 \
SERVER_PATH="/000000.html" \
LOG_NAME="test-001-http-big" \
MD5SUM="f5cb3755db2ccc1a740b266d91c73631" \
$SCRIPT_DIR/_run-single-download-test.sh

#end of file
