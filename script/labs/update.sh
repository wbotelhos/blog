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
      echo -e "\n${GRAY}Pulling ${slug}...${NO_COLOR}"

      cd ~/workspace/${slug}
      git pull origin master
      cd -
    else
      echo -e "\n${GRAY}Cloning ${slug}...${NO_COLOR}"

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
