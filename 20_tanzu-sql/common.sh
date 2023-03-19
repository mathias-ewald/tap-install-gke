#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/../common.sh

TDS_DIR="$SCRIPT_DIR/config"

function setup_namespace() {
  NAMESPACE=$1

  tanzu package repository add tanzu-data-services-repository \
      --url $INSTALL_REGISTRY_HOSTNAME/$INSTALL_REGISTRY_REPO/tds-packages:$TDS_VERSION \
      --namespace $NAMESPACE \
      --create-namespace
  
  kubectl create secret docker-registry regsecret \
      --namespace $NAMESPACE \
      --docker-server=$INSTALL_REGISTRY_HOSTNAME \
      --docker-username="_json_key" \
      --docker-password="$(cat $GOOGLE_APPLICATION_CREDENTIALS)" \
      --dry-run=client -o yaml | kubectl apply -f -
}
