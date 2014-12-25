#!/bin/bash

##########################
# --- Configurations --- #
##########################

GRAY='\033[0;36m'
GREEN='\033[0;32m'
NO_COLOR='\033[1;0m'

JOB_NAME='Labs#update'

#####################
# --- Functions --- #
#####################

begin() {
  echo -e "-------------------------------------"
  echo -e "${GRAY}Starting ${JOB_NAME}...${NO_COLOR}\n"
}

end() {
  echo -e "${GREEN}Done!${NO_COLOR}"
  echo -e "-------------------------------------\n"
}

pull() {
  cd ~/workspace

  while read slug; do
    if [ -d $slug ]; then
      cd ~/workspace/${slug}
      git pull origin master
      cd -
    else
      git clone "git@github.com:wbotelhos/${slug}.git"
    fi
  done < ~/workspace/blogy/script/labs/slugs.txt
}

#####################
# ---- Install ---- #
#####################

begin

pull

end
