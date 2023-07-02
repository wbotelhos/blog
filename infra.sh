#!/bin/sh

TERRAFORM_VERSION="${TERRAFORM_VERSION:-1.5.2}" # https://www.terraform.io/downloads.html

if [ -z ${CLOUDFLARE_ACCOUNT_ID} ]; then
  echo '[ERROR] "CLOUDFLARE_ACCOUNT_ID" var is missing!';

  exit 2;
fi

if [ -z ${CLOUDFLARE_API_KEY} ]; then
  echo '[ERROR] "CLOUDFLARE_API_KEY" var is missing!';

  exit 2;
fi

if [ -z ${CLOUDFLARE_EMAIL} ]; then
  echo '[ERROR] "CLOUDFLARE_EMAIL" var is missing!';

  exit 2;
fi

cd infra/terraform
brew upgrade tfenv
tfenv install ${TERRAFORM_VERSION}
tfenv use ${TERRAFORM_VERSION}
terraform init -upgrade
terraform workspace new production
terraform workspace select production
terraform apply
