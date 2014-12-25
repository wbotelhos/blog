#!/bin/bash

GRAY='\033[0;36m'
GREEN='\033[0;32m'
NO_COLOR='\033[1;0m'

. script/labs/slugs.sh

cd ~/workspace

for SLUG in "${SLUGS[@]}"; do
  if [ -d $SLUG ]; then
    echo -e "\n${GRAY}Pulling ${SLUG}...${NO_COLOR}"

    cd $SLUG
    git pull origin master
  else
    echo -e "\n${GRAY}Cloning ${SLUG}...${NO_COLOR}"

    git clone "git@github.com:wbotelhos/${SLUG}.git"
  fi
done

cd ~/workspace/blogy
