#!/bin/bash

. script/colors.sh
. script/labs/slugs.sh

for SLUG in "${SLUGS[@]}"; do
  echo -e "\n${GRAY}Pulling ${SLUG}...${NO_COLOR}"

  cd ~/workspace/$SLUG
  git pull origin master
done

cd ~/workspace/blog
