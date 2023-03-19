#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

switch_cluster build

set +e
export KUBECTL_EXTERNAL_DIFF="colordiff -N -u"
kubectl -n $NAMESPACE diff -f $COMMON_DIR/scanpolicy-relaxed.yaml
DIFF=$?
set -e

set +x
if [ $DIFF -eq 0 ]; then
  exit 0
fi

read -p 'Do you want to proceed?: [yN] ' confirm
if [ $confirm != 'y' ]; then
  exit 0 
fi
set -x

kubectl -n $NAMESPACE apply -f $COMMON_DIR/scanpolicy-relaxed.yaml
