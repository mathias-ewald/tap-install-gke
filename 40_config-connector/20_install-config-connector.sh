#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

CONFIG_DIR=$SCRIPT_DIR/config

SA_EMAIL="$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"

switch_cluster run

ytt -f $CONFIG_DIR/config-connector.yaml \
  -v sa_email=$SA_EMAIL |
  kubectl apply -f -

kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -
kubectl annotate namespace $NAMESPACE cnrm.cloud.google.com/project-id=$PROJECT_ID
