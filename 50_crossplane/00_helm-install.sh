#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

helm repo add \
  crossplane-stable https://charts.crossplane.io/stable
  
helm repo update

helm upgrade --install crossplane \
  crossplane-stable/crossplane \
  --namespace crossplane-system \
  --create-namespace

