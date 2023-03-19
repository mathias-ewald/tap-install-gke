SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
COMMON_DIR=$SCRIPT_DIR/../common
source $COMMON_DIR/common.sh

NAMESPACE="dinner"
GIT_REPO="git@github.com:mathias-ewald/tap-demo-where-for-dinner.git"

CONFIG_DIR="$SCRIPT_DIR/config"
