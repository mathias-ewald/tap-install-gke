#!/bin/bash
set -euxo pipefail 

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

TANZUNET_USERNAME=${TANZUNET_USERNAME}
TANZUNET_PASSWORD=${TANZUNET_PASSWORD}
TAP_VERSION=${TAP_VERSION}
TBS_VERSION=${TBS_VERSION}
INSTALL_REGISTRY_HOSTNAME=${INSTALL_REGISTRY_HOSTNAME}
INSTALL_REGISTRY_REPO=${INSTALL_REGISTRY_REPO}
GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_APPLICATION_CREDENTIALS}

# We don't want imgpkg to try and use the VM's service account
export IMGPKG_ENABLE_IAAS_AUTH=false

echo "$TANZUNET_PASSWORD" | \
  docker login registry.tanzu.vmware.com -u $TANZUNET_USERNAME --password-stdin

cat $GOOGLE_APPLICATION_CREDENTIALS | \
  docker login $INSTALL_REGISTRY_HOSTNAME -u "_json_key" --password-stdin

imgpkg copy \
  -b registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:$CLUSTER_ESSENTIALS_BUNDLE_SHA \
  --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REGISTRY_REPO}/cluster-essentials-bundle \
  --include-non-distributable-layers

imgpkg copy \
  -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} \
  --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REGISTRY_REPO}/tap-packages \
  --include-non-distributable-layers

imgpkg copy \
  -b registry.tanzu.vmware.com/tanzu-application-platform/full-tbs-deps-package-repo:${TBS_VERSION} \
  --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REGISTRY_REPO}/tbs-full-deps

imgpkg copy \
  -b registry.tanzu.vmware.com/packages-for-vmware-tanzu-data-services/tds-packages:${TDS_VERSION} \
  --to-repo $INSTALL_REGISTRY_HOSTNAME/$INSTALL_REGISTRY_REPO/tds-packages

imgpkg copy \
  -b registry.tanzu.vmware.com/p-rabbitmq-for-kubernetes/tanzu-rabbitmq-package-repo:${RMQ_VERSION} \
  --to-repo $INSTALL_REGISTRY_HOSTNAME/$INSTALL_REGISTRY_REPO/rmq-packages

