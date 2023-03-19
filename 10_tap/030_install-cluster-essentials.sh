#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOWNLOADS_DIR="$SCRIPT_DIR/downloads"

source $SCRIPT_DIR/common.sh

export INSTALL_REGISTRY_HOSTNAME=${INSTALL_REGISTRY_HOSTNAME}
INSTALL_REGISTRY_REPO=${INSTALL_REGISTRY_REPO}
export INSTALL_BUNDLE="$INSTALL_REGISTRY_HOSTNAME/$INSTALL_REGISTRY_REPO/cluster-essentials-bundle@sha256:$CLUSTER_ESSENTIALS_BUNDLE_SHA"
export INSTALL_REGISTRY_USERNAME="_json_key"
export INSTALL_REGISTRY_PASSWORD="$(cat $GOOGLE_APPLICATION_CREDENTIALS)"


# Check if Tanzu Cluster Essentials bundle is available
FILE_PATH="$DOWNLOADS_DIR/tanzu-cluster-essentials.tgz"
if [ ! -f $FILE_PATH ]; then
    echo "Download file $FILE_NAME from Tanzu Network and run again."
fi

# Extract Tanzu Cluster Essentials
CLUSTER_ESSENTIALS_DIR=$DOWNLOADS_DIR/tanzu-cluster-essentials
if [ -d $CLUSTER_ESSENTIALS_DIR ]; then
  rm -fR $CLUSTER_ESSENTIALS_DIR
fi
mkdir $CLUSTER_ESSENTIALS_DIR
tar xvf $FILE_PATH -C $CLUSTER_ESSENTIALS_DIR > /dev/null 2>&1

# Login to the registry
cat $GOOGLE_APPLICATION_CREDENTIALS | \
  docker login $INSTALL_REGISTRY_HOSTNAME -u _json_key --password-stdin

# Install Tanzu Cluster Essentials
pushd $CLUSTER_ESSENTIALS_DIR
  for I in $(kubectl config get-contexts -o name | grep tap-demo); do
    kubectl config use-context $I
    ./install.sh --yes
  done
popd
