ENVIRONMENT=${ENVIRONMENT}

export TF_VAR_environment=$ENVIRONMENT

cat <<EOF > backend.config
bucket = "tap-${ENVIRONMENT}-config-connector-tfstate"
prefix = ""
EOF
