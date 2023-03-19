#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

NAMESPACE="$NAMESPACE"

switch_cluster build
DELIVERABLE_YAML="$(kubectl get configmap petclinic-deliverable --namespace $NAMESPACE -o go-template='{{.data.deliverable}}')"

switch_cluster run
echo "$DELIVERABLE_YAML" | kubectl apply --namespace $NAMESPACE -f -
