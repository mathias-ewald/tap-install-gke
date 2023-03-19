#!/bin/bash
set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source $SCRIPT_DIR/common.sh

CONFIG_DIR=$SCRIPT_DIR/config

switch_cluster run

for I in gold silver bronze; do 

  ADMIN_SECRET_NAME="postgres-$I-admin-creds"
  ADMIN_PASSWORD="$(openssl rand -base64 32)"
  ytt -f $CONFIG_DIR/user-secret.yaml \
    -v "name=$ADMIN_SECRET_NAME" \
    -v "password=$ADMIN_PASSWORD" \
    | kubectl apply -f -

  USER_SECRET_NAME="postgres-$I-user-creds"
  USER_PASSWORD="$(openssl rand -base64 32)"
  ytt -f $CONFIG_DIR/user-secret.yaml \
    -v "name=$USER_SECRET_NAME" \
    -v "password=$USER_PASSWORD" \
    | kubectl apply -f -

  ytt -f $CONFIG_DIR/sql-instance.yaml \
    -v "name=postgres-$I" \
    -v "type=POSTGRES_14" \
    -v "region=europe-west1" \
    -v "secret_name=$ADMIN_SECRET_NAME" \
    -v "tier=db-g1-small" \
    | kubectl apply -f -

  ytt -f $CONFIG_DIR/sql-database.yaml \
    -v "name=$I-default" \
    -v "instance_name=postgres-$I" \
    | kubectl apply -f -

  ytt -f $CONFIG_DIR/sql-user.yaml \
    -v "name=$I-user" \
    -v "instance_name=postgres-$I" \
    -v "secret_name=$USER_SECRET_NAME" \
    | kubectl apply -f -

  ytt -f $CONFIG_DIR/secret-template.yaml \
    -v "name=postgres-$I" \
    -v "instance_name=postgres-$I" \
    -v "database_name=$I-default" \
    -v "user_name=$I-user" \
    -v "service_class=cloudsql-postgres" \
    | kubectl apply -f -

done

ytt -f $CONFIG_DIR/postgres-class.yaml \
  -v "name=cloudsql-postgres" \
  -v "service_class=cloudsql-postgres" \
  -v "description=CloudSQL Postgres" \
  | kubectl apply -f -

ytt -f $CONFIG_DIR/resource-claim-policy.yaml \
  -v "name=all-can-claim-cloudsql-postgres" \
  -v "service_class=cloudsql-postgres" \
  | kubectl apply -f -






