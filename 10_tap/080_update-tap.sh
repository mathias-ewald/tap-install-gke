#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

NAMESPACE="tap-install"
TAP_DIR=$SCRIPT_DIR/config/tap

install_or_update_tap
