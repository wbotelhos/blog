#!/bin/bash

cd /var/www/blog/current

source ~/.bash_aliases

echo "[whenever][$(whoami)] restarting unicorn..."
echo "[whenever][GEM_HOME] ${GEM_HOME}"
echo "[whenever][GEM_PATH] ${GEM_PATH}"
echo "[whenever][Ruby] $(ruby -v)"

DATA_MIGRATER=false RAILS_ENV=production bundle exec whenever -s environment=production -i blog
