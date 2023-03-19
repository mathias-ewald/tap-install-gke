#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

TAP_VERSION="${TAP_VERSION}"
TBS_VERSION="${TBS_VERSION}"

NAMESPACE="tap-install"
TAP_DIR=$SCRIPT_DIR/config/tap

for PROFILE in view iterate build run; do
  switch_cluster $PROFILE

  kubectl create clusterrolebinding tap-psp-rolebinding \
    --group=system:authenticated \
    --clusterrole=gce:podsecuritypolicy:privileged \
    --dry-run=client -o yaml | kubectl apply -f -

  generate_values $PROFILE
done

install_or_update_tap
