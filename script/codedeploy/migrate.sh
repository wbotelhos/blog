#!/bin/bash

cd /var/www/blog/codedeploy

source ~/.bash_aliases

echo "[migrate][$(whoami)] restarting unicorn..."
echo "[migrate][GEM_HOME] ${GEM_HOME}"
echo "[migrate][GEM_PATH] ${GEM_PATH}"
echo "[migrate][Ruby] $(ruby -v)"

DATA_MIGRATER=false RAILS_ENV=production bundle exec rake db:migrate
