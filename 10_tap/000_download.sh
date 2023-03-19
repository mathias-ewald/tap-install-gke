#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

REFRESH_TOKEN="${TANZUNET_REFRESH_TOKEN}"
DOWNLOAD_DIR="$SCRIPT_DIR/downloads"

mkdir -p $DOWNLOAD_DIR

# Wipe the directory
rm -fR $DOWNLOAD_DIR/*

# Authenticate with Tanzu Network
TOKEN=$(curl -s -X POST https://network.tanzu.vmware.com/api/v2/authentication/access_tokens -d "{\"refresh_token\":\"$REFRESH_TOKEN\"}" | jq .access_token -r)

# Download required files
function tanzunet_download () {
  FILE_NAME=$1
  PRODUCT_ID=$2
  RELEASE_ID=$3
  PRODUCT_FILE_ID=$4
  wget -O "$DOWNLOAD_DIR/$FILE_NAME" \
    --header="Authorization: Bearer $TOKEN"\
    https://network.tanzu.vmware.com/api/v2/products/$PRODUCT_ID/releases/$RELEASE_ID/product_files/$PRODUCT_FILE_ID/download
}


# https://network.tanzu.vmware.com/api/v2/products/tanzu-application-platform/releases/1260043/product_files/1433868/download
tanzunet_download tanzu-framework.tar tanzu-application-platform 1260043 1433868

# https://network.tanzu.vmware.com/api/v2/products/tanzu-cluster-essentials/releases/1249982/product_files/1423994/download
tanzunet_download tanzu-cluster-essentials.tgz tanzu-cluster-essentials 1249982 1423994
