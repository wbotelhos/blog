# Blog on Rails

[![CI](https://github.com/wbotelhos/danca/workflows/CI/badge.svg?)](https://github.com/wbotelhos/danca/actions?query=workflow%3ACI)
[![Maintainability](https://api.codeclimate.com/v1/badges/77c48bc2ae425721e774/maintainability)](https://codeclimate.com/github/wbotelhos/blogy/maintainability)
[![codecov](https://codecov.io/gh/wbotelhos/blogy/branch/master/graph/badge.svg?token=VX93Oihxpz)](https://codecov.io/gh/wbotelhos/blogy)
[![Patreon](https://img.shields.io/badge/donate-%3C3-brightgreen.svg)](https://www.patreon.com/wbotelhos)

## Application ENVs

```sh
ASSET_HOST=https://{bucket_name}.s3[-{region}].amazonaws.com
RAILS_MASTER_KEY={key}
```

## Making a Release

```sh
ASSETS_BUCKET=... \
AWS_ACCESS_KEY_ID=... \
AWS_SECRET_ACCESS_KEY=... \
ECR_ID=... \
REGION=... \
REPOSITORY=... \
TAG=... \
./script/ci/release.sh
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

Need install ruby version of file [.ruby-version](.ruby-version).

```sh
bundle install
rails s
```
