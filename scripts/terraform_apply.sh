#!/bin/sh
set -x

cd infra

terraform init -backend-config="env/backend.tfvars"

terraform apply --var-file="env/${ENV}.tfvars" -auto-approve
