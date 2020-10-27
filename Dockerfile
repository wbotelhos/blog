FROM ruby:2.6.6-slim

ENV BUNDLE_DEPLOYMENT=true
ENV BUNDLE_PATH=vendor/bundle
ENV BUNDLER_WITHOUT=development:test
ENV LANG=C.UTF-8
ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true

WORKDIR /var/www/app

COPY Gemfile* ./

RUN apt-get update -qq && apt-get install -y awscli build-essential libmariadb-dev nodejs

RUN gem install bundler -v '~> 2' --no-document

RUN bundle install --jobs=4

COPY . /var/www/app

ARG ASSETS_BUCKET=none
ARG AWS_ACCESS_KEY_ID=none
ARG AWS_SECRET_ACCESS_KEY=none

RUN AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
  AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
  SECRET_KEY_BASE=secret_key_base \
  script/ci/assets_precompile.sh

CMD ["bundle", "exec", "puma"]
