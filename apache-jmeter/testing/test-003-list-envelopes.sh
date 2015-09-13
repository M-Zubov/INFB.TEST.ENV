#!/bin/bash

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"

TEST_PLAN_PATH=$SCRIPT_DIR/jmx/test-static.jmx \
SERVER_PORT=9080 \
SERVER_PATH="/cloudStorage$NODE/v1.0/DICOMEnvelope" \
LOG_NAME="test-004-list-envelopes$NODE" \
$SCRIPT_DIR/_run-single-test.sh

#end of file
