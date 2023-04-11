#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

kubectl wait --for=condition=Ready pods --all -n crossplane-system

kubectl get pods -n crossplane-system

kubectl api-resources  | grep crossplane

