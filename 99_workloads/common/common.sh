DOMAIN="tap.halusky.net"

function switch_cluster() {
  PROFILE=$1
  CTX=$(kubectl config get-contexts -o name | grep $PROFILE | head -n1)
  kubectl config use-context $CTX 2>&1 > /dev/null
}

function setup_dev_service_account() {
  NAMESPACE=$1
  kubectl -n $NAMESPACE apply -f $CONFIG_DIR/dev-user-rbac.yaml
}

function generate_kubeconfig() {
  NAMESPACE=$1
  SECRET_NAME="dev-user-token"
  SERVER=$(kubectl config view --minify --output 'jsonpath={..cluster.server}')
  CLUSTER=$(kubectl config view --minify --output 'jsonpath={..context.cluster}')
  CA=$(kubectl -n $NAMESPACE get secret $SECRET_NAME -o jsonpath='{.data.ca\.crt}')
  TOKEN=$(kubectl -n $NAMESPACE get secret $SECRET_NAME -o jsonpath='{.data.token}' | base64 --decode)

echo "\
apiVersion: v1
kind: Config
clusters:
- name: ${CLUSTER}
  cluster:
    certificate-authority-data: ${CA}
    server: ${SERVER}
contexts:
- name: default-context
  context:
    cluster: ${CLUSTER}
    namespace: ${NAMESPACE}
    user: default-user
current-context: default-context
users:
- name: default-user
  user:
    token: ${TOKEN}"
}



function setup_dev_namespaces() {
  NAMESPACE=$1
  for I in iterate build run; do
    switch_cluster $I
    kubectl create ns --dry-run=client -o yaml $NAMESPACE | kubectl apply -f -
    kubectl label namespaces $NAMESPACE apps.tanzu.vmware.com/tap-ns=""
  done
}

function delete_dev_namespaces() {
  NAMESPACE=$1
  for I in iterate build run; do
    switch_cluster $I
    kubectl delete ns --wait=false $NAMESPACE
  done
}


function show_build_resources_kubectl() {
  NAMESPACE=$1
  kubectl -n $NAMESPACE get gitrepositories,pipelinerun,sourcescan,image,imagescan,configmaps,pods
}

export -f show_build_resources_kubectl

function watch_build_resources_kubectl() {
  NAMESPACE=$1
  watch -x bash -c "show_build_resources_kubectl $NAMESPACE"
}

function watch_build_resources_tanzucli() {
  NAMESPACE=$1
  WORKLOAD=$2
  watch "tanzu -n $NAMESPACE app workload get $WORKLOAD"
}


function show_run_resources() {
  NAMESPACE=$1
  kubectl -n $NAMESPACE get deliverable,app,kservice,deployment,replicaset,pod,cm,servicebindings
}

export -f show_run_resources

function watch_run_resources() {
  NAMESPACE=$1
  watch -x bash -c "show_run_resources $NAMESPACE"
}

function tail_workload() {
  NAMESPACE=$1
  NAME=$2
  tanzu -n $NAMESPACE app workload tail $NAME
}
