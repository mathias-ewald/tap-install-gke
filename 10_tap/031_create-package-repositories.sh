#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

INSTALL_REGISTRY_HOSTNAME=${INSTALL_REGISTRY_HOSTNAME}
INSTALL_REGISTRY_REPO=${INSTALL_REGISTRY_REPO}
INSTALL_REGISTRY_USERNAME="_json_key"
GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_APPLICATION_CREDENTIALS}
TAP_VERSION=${TAP_VERSION}
TBS_VERSION=${TBS_VERSION}

for I in $(kubectl config get-contexts -o name | grep tap-demo); do
  kubectl config use-context $I

  kubectl create namespace tap-install --dry-run=client -o yaml | kubectl apply -f -

  tanzu secret registry add tap-registry \
    --username ${INSTALL_REGISTRY_USERNAME} \
    --password-file $GOOGLE_APPLICATION_CREDENTIALS \
    --server ${INSTALL_REGISTRY_HOSTNAME} \
    --export-to-all-namespaces --yes --namespace tap-install

  tanzu package repository add tanzu-tap-repository \
    --url ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REGISTRY_REPO}/tap-packages:$TAP_VERSION \
    --namespace tap-install

  tanzu package repository add tbs-full-deps-repository \
    --url ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REGISTRY_REPO}/tbs-full-deps:${TBS_VERSION} \
    --namespace tap-install

  tanzu package repository get tanzu-tap-repository --namespace tap-install
  tanzu package available list --namespace tap-install
done
