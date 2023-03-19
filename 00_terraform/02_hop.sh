#!/bin/bash

export GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_APPLICATION_CREDENTIALS}

pushd terraform
JUMPBOX_NAME="$(terraform output -raw jumphost_name)"
JUMPBOX_ZONE="$(terraform output -raw jumphost_zone)"
popd

gcloud compute ssh $JUMPBOX_NAME \
  --zone=$JUMPBOX_ZONE \
  --tunnel-through-iap \
  --ssh-flag="-A"
