#!/bin/sh
set -x

cd infra

terraform init -backend-config="env/backend.tfvars"

terraform plan --var-file="env/${ENV}.tfvars"

terraform show