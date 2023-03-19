ENVIRONMENT=${ENVIRONMENT}

export TF_VAR_environment=$ENVIRONMENT

cat <<EOF > terraform/backend.config
bucket = "tap-${ENVIRONMENT}-tfstate"
prefix = ""
EOF
