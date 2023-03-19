#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/../common.sh

NAMESPACE="service-instances"
SERVICE_ACCOUNT_NAME="tap-$ENVIRONMENT-config-connector"
