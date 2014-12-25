#!/bin/bash

GRAY='\033[0;36m'
GREEN='\033[0;32m'
NO_COLOR='\033[1;0m'

. script/labs/slugs.sh

echo -e "\n${GRAY}Linking labs into plublic directory...${NO_COLOR}"

for SLUG in "${SLUGS[@]}"; do
  FROM="~/workspace/${SLUG}"
  TO="public/${SLUG}"

  if [ -L "$TO" ]; then
    unlink $TO
  fi

  ln -s $FROM $TO
done
