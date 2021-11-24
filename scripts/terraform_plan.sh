#!/bin/sh
set -x

STATE_BUCKET="omni-ap-southeast-2-tf"

cd infra

terraform init \
  -backend-config="bucket=${STATE_BUCKET}"
  -backend-config="region=${REGION}"

terraform workspace list
terraform workspace select ${ENV} || terraform workspace new ${ENV}

terraform plan --var-file="infra/env/${ENV}.tfvars"

terraform show