#!/bin/bash

##########################
# --- Configurations --- #
##########################

GRAY='\033[0;36m'
GREEN='\033[0;32m'
NO_COLOR='\033[1;0m'

JOB_NAME='Labs#link'

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

link() {
  while read slug; do
    ln -sfn "~/workspace/${slug}" "public/${slug}"
  done < ~/workspace/blogy/script/labs/slugs.txt
}

#####################
# ---- Install ---- #
#####################

begin

link

end
