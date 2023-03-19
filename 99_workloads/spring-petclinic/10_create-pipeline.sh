#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

switch_cluster build

kubectl -n $NAMESPACE apply -f $COMMON_DIR/pipeline-noop.yaml
