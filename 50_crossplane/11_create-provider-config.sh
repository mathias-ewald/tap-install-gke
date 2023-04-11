#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

kubectl create secret \
  generic gcp-secret \
  -n crossplane-system \
  --from-file=creds=$GOOGLE_APPLICATION_CREDENTIALS \
  --dry-run=client -o yaml | kubectl apply -f -

ytt -f $SCRIPT_DIR/provider-config.yaml \
  -v project_id=$PROJECT_ID \
  | kubectl apply -f -

