#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

cat <<EOF
#####################################################################################
# This step should be part of the Terraform that creates the cluster. At the time of
# writing this, the latest version of the Terrform module does not support that, yet.
#####################################################################################
EOF

gcloud container node-pools update default-node-pool \
  --region $REGION \
  --workload-metadata=GKE_METADATA \
  --cluster tap-demo-run

gcloud container clusters update tap-demo-run \
  --region $REGION \
  --update-addons ConfigConnector=ENABLED


