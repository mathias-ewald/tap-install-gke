#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_DIR=$SCRIPT_DIR/../common
source $SCRIPT_DIR/common.sh

switch_cluster run

setup_dev_namespaces $NAMESPACE
# setup_dev_service_account $NAMESPACE
# generate_kubeconfig $NAMESPACE > $SCRIPT_DIR/kubeconfig-$NAMESPACE-dev-run.yaml
