#!/bin/bash
set -uxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

switch_cluster run
kubectl -n $NAMESPACE delete deliverable petclinic

switch_cluster build
kubectl -n $NAMESPACE delete workload petclinic
