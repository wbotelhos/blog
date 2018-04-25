#!/bin/bash

cd /var/www/blog/codedeploy

source ~/.bash_aliases

echo "[precompile][$(whoami)] restarting unicorn..."
echo "[precompile][GEM_HOME] ${GEM_HOME}"
echo "[precompile][GEM_PATH] ${GEM_PATH}"
echo "[precompile][Ruby] $(ruby -v)"

DATA_MIGRATER=false RAILS_ENV=production bundle exec rake assets:precompile --silent
