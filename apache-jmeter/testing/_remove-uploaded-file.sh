#!/bin/bash

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"

# get id of a previously uploaded file
FILE_ID=`cat $SCRIPT_DIR/.uploaded-file-id.txt`

# remove file used for testing
curl http://172.16.0.116:9080/cloudStorage/v1.0/DICOMEnvelope/delete?id=$FILE_ID

# end of file
