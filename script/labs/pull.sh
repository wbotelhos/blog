#!/bin/bash

. script/colors.sh
. script/labs/load_labs.sh

for LAB in "${LABS[@]}"; do
  cd ~/workspace

  if [ -d "${LAB}" ]; then
    echo -e "\n${GRAY}Pulling ${LAB}...${NO_COLOR}"

    cd $LAB
    git pull origin master
  else
    echo -e "\n${GRAY}Cloning ${LAB}...${NO_COLOR}"

    git clone "git@github.com:wbotelhos/${LAB}.git"
  fi
done
