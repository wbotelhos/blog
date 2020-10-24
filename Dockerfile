FROM ruby:2.6.6-slim

ENV LANG C.UTF-8

WORKDIR /var/www/app

COPY Gemfile* ./

RUN apt-get update -qq && apt-get install -y build-essential libmariadb-dev nodejs

RUN bundle install

COPY . /var/www/app

CMD ["bundle", "exec", "puma"]
