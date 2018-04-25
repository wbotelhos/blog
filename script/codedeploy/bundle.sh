#!/bin/bash

cd /var/www/blog/codedeploy

source ~/.bash_aliases

echo "[bundle][$(whoami)] restarting unicorn..."
echo "[bundle][GEM_HOME] ${GEM_HOME}"
echo "[bundle][GEM_PATH] ${GEM_PATH}"
echo "[bundle][Ruby] $(ruby -v)"

gem install bundler --no-document

RAILS_ENV=production bundle install --deployment --without development test --quiet
