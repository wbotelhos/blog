#!/bin/bash

ECR_URL=${ECR_ID}.dkr.ecr.${REGION}.amazonaws.com

aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_URL}

REPOSITORY=${REPOSITORY}
TAG=v${TAG}

docker build . -t ${REPOSITORY}:${TAG} \
  --build-arg ASSETS_BUCKET=${ASSETS_BUCKET} \
  --build-arg AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
  --build-arg AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}

docker tag ${REPOSITORY}:${TAG} ${ECR_URL}/${REPOSITORY}:${TAG}
docker push ${ECR_URL}/${REPOSITORY}:${TAG}
