#!/bin/bash

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"

TEST_PLAN_PATH=$SCRIPT_DIR/jmx/test-static.jmx \
SERVER_PORT=9080 \
SERVER_PATH="/" \
LOG_NAME="test-003-client" \
$SCRIPT_DIR/_run-single-test.sh

#end of file
