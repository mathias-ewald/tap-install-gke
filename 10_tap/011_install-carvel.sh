#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOWNLOADS_DIR="$SCRIPT_DIR/downloads"

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

# Install Tanzu Cluster Essentials
pushd $CLUSTER_ESSENTIALS_DIR
  # Install Carvel tools locally
  for I in imgpkg kapp kbld ytt; do 
    sudo install ./$I /usr/local/bin/$I
    $I --version
  done
popd
