#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

NAMESPACE=$NAMESPACE

switch_cluster run
kubectl -n $NAMESPACE get kservice petclinic -o jsonpath='{.status.url}'
