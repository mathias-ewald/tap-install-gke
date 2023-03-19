#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

TDS_DIR="$SCRIPT_DIR/config"

NAMESPACE="postgres-tanzu-operator"

function install_postgres() {
  setup_namespace $NAMESPACE
  
  ACTION=$(check_install_or_update $NAMESPACE postgres-operator)
  tanzu package $ACTION postgres-operator \
      --package-name postgres-operator.sql.tanzu.vmware.com \
      --version $POSTGRES_VERSION \
      --namespace postgres-tanzu-operator \
      -f $TDS_DIR/postgres.yaml
}

for I in view run; do 
  switch_cluster $I
  install_postgres
done
