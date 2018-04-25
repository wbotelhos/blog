#!/bin/bash

APP='blog'
GROUP='production'
REPOSITORY='wbotelhos/blogy'

echo "[deployer] ${APP} -> ${GROUP} from ${REPOSITORY} starting..."

APPLICATION_NAME="--application-name $APP"
REGION='--region us-east-1'

# READ

if [[ -n $1 ]]; then
  COMMIT_ID=$1

  echo "[deployer] deploying commit: ${COMMIT_ID}"
else
  MAX_ITEMS=''
  SORT_BY='--sort-by lastUsedTime'
  SORT_ORDER='--sort-order descending'
  JSON=$(aws deploy list-application-revisions $APPLICATION_NAME $REGION $SORT_BY $SORT_ORDER $MAX_ITEMS)
  COMMIT_ID=$(echo $JSON | perl -nle 'print $& if m{commitId": "(.+)"}' | cut -d'"' -f3)

  echo "[deployer] deploying last commit: ${COMMIT_ID}"
fi

# DEPLOY

DEPLOYMENT_GROUP_NAME="--deployment-group-name $GROUP"
GITHUB_LOCATION="--github-location repository=${REPOSITORY},commitId=${COMMIT_ID}"

RESULT=$(aws deploy create-deployment $APPLICATION_NAME $REGION $DEPLOYMENT_GROUP_NAME $GITHUB_LOCATION)

if [[ -n $RESULT ]]; then
  DEPLOYMENT_ID=$(echo $RESULT | perl -nle 'print $& if m{deploymentId": "(.+)"}' | cut -d'"' -f3)
  URL="https://console.aws.amazon.com/codedeploy/home?region=us-east-1#/deployments/${DEPLOYMENT_ID}"

  echo "[deployer] deployment id: ${DEPLOYMENT_ID} (${URL})."
else
  echo "[deployer] aws deploy command failed!"
fi
