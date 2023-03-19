#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS

terraform init -backend-config=backend.config -var-file="variables.tfvars" 

gcloud auth activate-service-account tap-demo-terraform@cso-pcfs-emea-mewald.iam.gserviceaccount.com \
  --key-file=$GOOGLE_APPLICATION_CREDENTIALS \
  --project=$PROJECT_ID

for I in build iterate run view; do
  pushd terraform
  TERRAFORM_OUTPUT="${I}_cluster_name"
  CLUSTER_NAME="$(terraform output -raw $TERRAFORM_OUTPUT)"
  popd
  gcloud container clusters get-credentials $CLUSTER_NAME \
    --region $REGION \
    --project $PROJECT_ID
done

kubectl config get-contexts
