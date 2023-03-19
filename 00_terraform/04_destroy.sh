#!/bin/bash
set -uxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

terraform destroy -var-file="variables.tfvars" 

BUCKET_NAME="gs://tap-$ENVIRONMENT-tfstate"
gsutil rm -r $BUCKET_NAME

SA_NAME="tap-${ENVIRONMENT}-terraform"
SA_EMAIL=$(gcloud iam service-accounts list --format="json" | jq --arg EMAIL "$SA_NAME" '.[] | select(.email | contains ($EMAIL)) | .email' -r)

gcloud iam service-accounts delete $SA_EMAIL --quiet

