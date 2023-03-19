#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

pushd $SCRIPT_DIR/code/where-for-dinner
  git init
  git add .
  git commit -m "first commit"
  git branch -M main
  git remote add origin $GIT_REPO
  git push -u origin main --force
popd
