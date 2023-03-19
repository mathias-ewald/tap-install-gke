#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

# Create service account to run Terraform
SA_NAME="tap-${ENVIRONMENT}-terraform"

set +e
gcloud iam service-accounts create $SA_NAME \
    --description="Service account for Terraform in the ${ENVIRONMENT} environment" \
    --display-name="TAP Terraform ${ENVIRONMENT}"
RETVAL=$?
set -e

if [ $RETVAL -eq 0 ]; then
  gcloud projects add-iam-policy-binding "$PROJECT_ID" \
      --member="serviceAccount:${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
      --role="roles/owner"
  
  gcloud iam service-accounts keys create ${SA_NAME}.json \
      --iam-account=${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
fi

# Create GCS bucket for Terraform state

BUCKET_NAME="gs://tap-$ENVIRONMENT-tfstate"
set +e
gsutil ls | grep $BUCKET_NAME > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "Bucket $BUCKET_NAME already exists."
else
  BUCKET_NAME="gs://tap-$ENVIRONMENT-tfstate"
  echo "Creating bucket $BUCKET_NAME"
  gsutil mb \
    -p "$PROJECT_ID" \
    -c "STANDARD" \
    -l "$REGION" \
    -b on \
    $BUCKET_NAME
fi
set -e
