#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

TAP_DIR=$SCRIPT_DIR/config/tap
TLS_DIR=$SCRIPT_DIR/config/tls

function install_clusterissuers() {
  PROFILE=$1
  ytt -f $TLS_DIR/cluster-issuer.yaml -f $TAP_DIR/config.yaml -f $TAP_DIR/secrets.yaml | kubectl apply -f -
  ytt -f $TLS_DIR/certificates-$PROFILE.yaml -f $TAP_DIR/config.yaml -f $TAP_DIR/secrets.yaml | kubectl apply -f -
}

for I in run view; do 
  switch_cluster $I
  install_clusterissuers $I
done
