#!/bin/bash

##########################
# --- Configurations --- #
##########################

GRAY='\033[0;36m'
GREEN='\033[0;32m'
NO_COLOR='\033[1;0m'

JOB_NAME='Labs#dump'

#####################
# --- Functions --- #
#####################

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

dump() {
  bundle exec rake labs:dump
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

sync_dev() {
  if [ -n "$1" ]; then
    ~/workspace/blogy/script/database/production_to_development.sh $1
  fi
}

#####################
# ---- Install ---- #
#####################

begin

sync_dev
dump

end
