#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

NAMESPACE="tanzu-rabbitmq-operator"

function install_rabbitmq() {
  tanzu package repository add tanzu-rabbitmq-repository \
    --url $INSTALL_REGISTRY_HOSTNAME/$INSTALL_REGISTRY_REPO/rmq-packages:$RMQ_VERSION \
    --namespace $NAMESPACE \
    --create-namespace
  
  kubectl create secret docker-registry regsecret \
    --namespace $NAMESPACE \
    --docker-server=$INSTALL_REGISTRY_HOSTNAME \
    --docker-username="_json_key" \
    --docker-password="$(cat $GOOGLE_APPLICATION_CREDENTIALS)" \
    --dry-run=client -o yaml | kubectl apply -f -
  
  ACTION=$(check_install_or_update rabbitmq-operator $NAMESPACE)
  tanzu package $ACTION rabbitmq-operator \
      --package-name rabbitmq.tanzu.vmware.com \
      --version $RMQ_VERSION \
      --namespace $NAMESPACE \
      -f $RMQ_DIR/rabbitmq.yaml
}

for I in run; do
  switch_cluster $I
  install_rabbitmq
done
