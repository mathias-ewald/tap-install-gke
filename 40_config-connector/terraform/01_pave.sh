#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

terraform init -backend-config=backend.config -var-file="variables.tfvars" 
terraform apply -var-file="variables.tfvars" 
