#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

ACCEL_URL="https://accelerator.${DOMAIN}"

tanzu accelerator list --server-url $ACCEL_URL

set +x
read -p 'Do you want to generate the accelerator "where-for-dinner"?: [yN] ' confirm
if [ $confirm != 'y' ]; then
  exit 0 
fi
set -x

tanzu accelerator generate --server-url $ACCEL_URL where-for-dinner \
  --options-file $CONFIG_DIR/accelerator-options.json \
  --output-dir $SCRIPT_DIR/code

pushd $SCRIPT_DIR/code
  unzip where-for-dinner.zip
  tree -L 2
popd
