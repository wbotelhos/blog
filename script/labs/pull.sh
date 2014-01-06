#!/bin/bash

. script/colors.sh
. script/labs/config.sh

for LAB in "${LABS[@]}"; do
  cd ~/workspace/"${LAB}"

  echo -e "\n${GRAY}Pulling ${LAB}...${NO_COLOR}"

  git pull
done
