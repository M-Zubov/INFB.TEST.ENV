#!/bin/bash

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"

TEST_PLAN_PATH=$SCRIPT_DIR/jmx/test-static.jmx \
SERVER_PORT=80 \
SERVER_PATH="/000000.html" \
LOG_NAME="test-002-http-big" \
$SCRIPT_DIR/_run-single-test.sh

#end of file
