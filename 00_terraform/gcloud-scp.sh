#!/bin/bash

export GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_APPLICATION_CREDENTIALS}

JUMPBOX_NAME="$(terraform output -raw jumphost_name)"
JUMPBOX_ZONE="$(terraform output -raw jumphost_zone)"

PARAMS=`echo "$@" | gsed "s#JMP#$JUMPBOX_NAME#g"`

echo $PARAMS

gcloud compute scp --recurse \
  --zone=$JUMPBOX_ZONE \
  --tunnel-through-iap $PARAMS
