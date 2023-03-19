#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

NAMESPACE="tap-install"
TAP_DIR=$SCRIPT_DIR/config/tap

# Copy SCST Store CA cert and auth token
switch_cluster view
CA_CERT=$(kubectl get secret -n tanzu-system-ingress tap-cert -o json | jq -r ".data.\"tls.crt\"")
METADATA_STORE_TOKEN=$(kubectl get secrets metadata-store-read-write-client -n metadata-store -o jsonpath="{.data.token}" | base64 -d)

# Set up service accounts for tap-gui to view resources
for I in build run; do
  switch_cluster $I
  kubectl apply -f $TAP_DIR/tap-ui-sa.yaml
  kubectl apply -f $TAP_DIR/tap-ui-sa-secret.yaml
  sleep 2
  declare ${I^^}_CLUSTER_URL=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
  declare ${I^^}_CLUSTER_TOKEN=$(kubectl -n tap-gui get secret tap-gui-viewer -o=json \
    | jq -r '.data["token"]' \
    | base64 --decode)
done

# Regenerate configs and reconcile packages
for PROFILE in view iterate build run; do
  generate_values $PROFILE
done


switch_cluster build
kubectl create ns metadata-store-secrets --dry-run=client -o yaml | kubectl apply -f -

cat <<EOF | kubectl apply -f -
---
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: store-ca-cert
  namespace: metadata-store-secrets
data:
  ca.crt: $CA_CERT
EOF

kubectl create secret generic store-auth-token \
  --from-literal="auth_token=$METADATA_STORE_TOKEN" -n metadata-store-secrets \
  --dry-run=client -o yaml | kubectl apply -f -

cat <<EOF | kubectl apply -f -
---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretExport
metadata:
  name: store-ca-cert
  namespace: metadata-store-secrets
spec:
  toNamespaces:
  - "*"
---
apiVersion: secretgen.carvel.dev/v1alpha1
kind: SecretExport
metadata:
  name: store-auth-token
  namespace: metadata-store-secrets
spec:
  toNamespaces:
  - "*"
EOF


