# Blog on Rails

[![CI](https://github.com/wbotelhos/danca/workflows/CI/badge.svg?)](https://github.com/wbotelhos/danca/actions?query=workflow%3ACI)
[![Quality](https://api.codeclimate.com/v1/badges/77c48bc2ae425721e774/maintainability)](https://codeclimate.com/github/wbotelhos/blogy/maintainability)
[![codecov](https://codecov.io/gh/wbotelhos/blogy/branch/master/graph/badge.svg?token=OexoxMXNTJ)](https://codecov.io/gh/wbotelhos/blogy)

## Application ENVs

```sh
ASSET_HOST=https://{bucket_name}.s3[-{region}].amazonaws.com
RAILS_MASTER_KEY={key}
```

## Create Image

```sh
ECR_URL={ecr_id}.dkr.ecr.{region}.amazonaws.com
PROFILE={profile}

AWS_PROFILE=${PROFILE} aws ecr get-login-password --region REGION | docker login --username AWS --password-stdin ${ECR_URL}

REPOSITORY={repository}
TAG=v{tag}

docker build . -t ${REPOSITORY}:${TAG} \
  --build-arg ASSETS_BUCKET={bucket_name} \
  --build-arg AWS_ACCESS_KEY_ID={key_id} \
  --build-arg AWS_SECRET_ACCESS_KEY={access_key}

docker tag ${REPOSITORY}:${TAG} ${ECR_URL}/${REPOSITORY}:${TAG}
docker push ${ECR_URL}/${REPOSITORY}:${TAG}
```

## Run on Docker

```sh
docker run -it -p 3000:3000 blogy:v{tag} bundle exec rails s -b 0.0.0.0
```

## Run Application on Docker

```sh
docker-compose up -d

open http://0.0.0.0:3000
```

## Run Application local

Need install ruby version of file `.ruby-version`.

```sh
bundle install
rails s
```
