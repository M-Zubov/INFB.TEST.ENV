#!/bin/bash

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"

TEST_PLAN_PATH=$SCRIPT_DIR/jmx/test-static.jmx \
SERVER_PORT=8080 \
SERVER_PATH="/cloudStorage/images/000000.dcm" \
LOG_NAME="test-002-client" \
$SCRIPT_DIR/_run-single-test.sh

#end of file
