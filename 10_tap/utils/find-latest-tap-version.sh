#!/bin/bash
set -euxo pipefail

TANZUNET_USERNAME=${TANZUNET_USERNAME}
TANZUNET_PASSWORD=${TANZUNET_PASSWORD}

echo $TANZUNET_PASSWORD \
  | docker login -u "$TANZUNET_USERNAME" --password-stdin registry.tanzu.vmware.com

imgpkg tag list -i registry.tanzu.vmware.com/tanzu-application-platform/tap-packages \
  | grep -v sha \
  | sort -V \
  | grep -P '^\d+\.\d+\.\d+\s*$' \
  | tail -n1
