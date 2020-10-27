#!/bin/bash

bundle exec rails assets:precompile

aws s3 sync --acl public-read public/assets s3://${ASSETS_BUCKET}/assets
