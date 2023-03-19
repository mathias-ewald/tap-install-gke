#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

TDS_DIR="$SCRIPT_DIR/config"

NAMESPACE="mysql-tanzu-operator"

function install_mysql() {
  setup_namespace $NAMESPACE
  
  ACTION=$(check_install_or_update $NAMESPACE mysql-operator)
  tanzu package $ACTION mysql-operator \
      --package-name mysql-operator.with.sql.tanzu.vmware.com \
      --version $MYSQL_VERSION \
      --namespace mysql-tanzu-operator \
      -f $TDS_DIR/mysql.yaml
}

for I in run; do 
  switch_cluster $I
  install_mysql
done
