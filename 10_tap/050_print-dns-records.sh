#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source $SCRIPT_DIR/common.sh

TAP_DIR=$SCRIPT_DIR/config/tap
DOMAIN="$(cat $TAP_DIR/config.yaml | yq eval '.domain' -)"

switch_cluster view
VIEW_ADDR=$(ingress_address)

switch_cluster run
RUN_ADDR=$(ingress_address)

echo "tap-gui.$DOMAIN => $VIEW_ADDR"
echo "accelerator.$DOMAIN => $VIEW_ADDR"
echo "tlc.$DOMAIN => $VIEW_ADDR"
echo "*.cnrs.$DOMAIN => $RUN_ADDR"
echo "metadata-store.$DOMAIN => $VIEW_ADDR"
