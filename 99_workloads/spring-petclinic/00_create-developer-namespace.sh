#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_DIR=$SCRIPT_DIR/../common
source $SCRIPT_DIR/common.sh

# setup_dev_namespaces $NAMESPACE


switch_cluster build
setup_dev_service_account -n $NAMESPACE -N petop -r app-editor 
# generate_kubeconfig $NAMESPACE > $SCRIPT_DIR/kubeconfig-$NAMESPACE-dev-run.yaml
