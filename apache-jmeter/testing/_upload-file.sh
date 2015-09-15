#!/bin/bash

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"

# upload file for testing
FILE_ID=`curl http://10.16.0.2:9080/cloudStorage/v1.0/DICOMEnvelope/upload -F "dicom_file=@${SCRIPT_DIR}/data/000009.dcm" 2>/dev/null | grep '"id":' | grep -P -o "\d+"`

# dump uploaded file id to a file for future use
echo "$FILE_ID" > $SCRIPT_DIR/.uploaded-file-id.txt

echo uploaded filed id: $FILE_ID

# end of file
