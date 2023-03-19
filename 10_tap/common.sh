#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/../common.sh
source $SCRIPT_DIR/secrets.sh

TAP_DIR=$SCRIPT_DIR/config/tap

function ingress_address() {
  kubectl -n tanzu-system-ingress get svc envoy -o json | jq ".status.loadBalancer.ingress[] | .ip" -r
}

function generate_values() {
  PROFILE=$1

  set +e
  BUILD_CLUSTER_URL=${BUILD_CLUSTER_URL:-""}
  BUILD_CLUSTER_TOKEN=${BUILD_CLUSTER_TOKEN:-""}
  RUN_CLUSTER_URL=${RUN_CLUSTER_URL:-""}
  RUN_CLUSTER_TOKEN=${RUN_CLUSTER_TOKEN:-""}
  METADATA_STORE_TOKEN=${METADATA_STORE_TOKEN:-""}
  set -e

  ytt -v profile=$PROFILE \
    -v build_cluster_url=$BUILD_CLUSTER_URL \
    -v build_cluster_token=$BUILD_CLUSTER_TOKEN \
    -v run_cluster_url=$RUN_CLUSTER_URL \
    -v run_cluster_token=$RUN_CLUSTER_TOKEN \
    -v metadata_store_token=$METADATA_STORE_TOKEN \
    -f $TAP_DIR/values-template.yaml \
    -f $TAP_DIR/config.yaml \
    -f $TAP_DIR/github-auth.yaml \
    -f $TAP_DIR/secrets.yaml \
    > $TAP_DIR/values-$PROFILE.yaml
}

function install_or_update_tap() {
  for PROFILE in view iterate build run; do
    switch_cluster $PROFILE

    PKG_CMD="install"
    kubectl -n tap-install get packageinstall tap
    if [ $? -eq 0 ]; then
      TANZU_CLI_PACKAGE_CMD="installed update"
    fi

    tanzu package $PKG_CMD tap \
      -p tap.tanzu.vmware.com \
      -v "$TAP_VERSION" \
      --values-file $TAP_DIR/values-$PROFILE.yaml \
      --wait="false" \
      -n "$NAMESPACE"
  done
}
