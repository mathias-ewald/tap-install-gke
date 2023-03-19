#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

set +e
pushd $SCRIPT_DIR/code/where-for-dinner
  grep -rl perfect300rock catalog | xargs sed -i "s/perfect300rock.com/$DOMAIN/g"
  git add .
  git commit -a -m "Update catalog entities with correct URL"
  git push
popd
set -e

cat <<EOF
THE NEXT STEP MUST BE PERFORMED MANUALLY VIA TAP-GUI AKA BACKSTAGE

1. Navigate to https://tap-gui.$DOMAIN/catalog
2. Click "Register Entity"
3. Use the following URL as the "Repository URL"

https://YOUR_GIT_REPO/catalog/catalog-info.yaml

4. Finish the wizard
EOF
