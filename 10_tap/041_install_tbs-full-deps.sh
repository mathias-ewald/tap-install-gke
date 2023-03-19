#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

TBS_VERSION="${TBS_VERSION}"

for I in iterate build; do
  switch_cluster $I
  tanzu package install full-tbs-deps \
    -p full-tbs-deps.tanzu.vmware.com \
    -v ${TBS_VERSION} \
    --wait="false" \
    -n tap-install
done
