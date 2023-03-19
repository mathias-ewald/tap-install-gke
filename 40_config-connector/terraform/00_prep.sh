#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

# Create GCS bucket for Terraform state

BUCKET_NAME="gs://tap-$ENVIRONMENT-config-connector-tfstate"
set +e
gsutil ls | grep $BUCKET_NAME > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "Bucket $BUCKET_NAME already exists."
else
  echo "Creating bucket $BUCKET_NAME"
  gsutil mb \
    -p "$PROJECT_ID" \
    -c "STANDARD" \
    -l "$REGION" \
    -b on \
    $BUCKET_NAME
fi
set -e
