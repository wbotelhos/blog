#!/bin/bash

source ~/.bash_aliases

echo "[unicorn_restart][$(whoami)] restarting unicorn..."
echo "[unicorn_restart][GEM_HOME] ${GEM_HOME}"
echo "[unicorn_restart][GEM_PATH] ${GEM_PATH}"
echo "[unicorn_restart][Ruby] $(ruby -v)"

service unicorn stop
service unicorn start
