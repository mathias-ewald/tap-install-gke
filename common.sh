PLATFORM="linux"
TAP_VERSION="1.4.2"
TBS_VERSION="1.9.0"
TDS_VERSION="1.7.0"
RMQ_VERSION="1.3.0"
POSTGRES_VERSION="2.0.1"
MYSQL_VERSION="1.7.0"
INSTALL_REGISTRY_HOSTNAME="gcr.io"
INSTALL_REGISTRY_REPO="cso-pcfs-emea-mewald"
GOOGLE_APPLICATION_CREDENTIALS="$HOME/tap-demo-terraform.json"
CLUSTER_ESSENTIALS_BUNDLE_SHA="2354688e46d4bb4060f74fca069513c9b42ffa17a0a6d5b0dbb81ed52242ea44"

function switch_cluster() {
  PROFILE=$1
  CTX=$(kubectl config get-contexts -o name | grep $PROFILE | head -n1)
  kubectl config use-context $CTX 2>&1 > /dev/null
}

function check_install_or_update () {
    NAMESPACE=$1
    PACKAGE=$2
    OUTPUT="$(tanzu package installed get -n "$NAMESPACE" "$PACKAGE" 2>&1)"
    if echo "$OUTPUT" | grep 'does not exist in namespace' 2>&1 > /dev/null; then
      echo "install"
      return
    fi 
    echo "installed update"
}

function decoded_k8s_secret_key() {
  NAMESPACE=$1
  NAME=$2
  KEY=$3
  kubectl -n $NAMESPACE get secret $NAME -o jsonpath="{ .data.$KEY }" | base64 -d
}
