#!/bin/bash

. script/colors.sh
. script/labs/slugs.sh

echo -e "\n${GRAY}Linking labs into plublic directory...${NO_COLOR}"

for SLUG in "${SLUGS[@]}"; do
  FROM=~/workspace/"${SLUG}"
  TO="public/${SLUG}"

  if [ -L "$TO" ]; then
    unlink $TO
  fi

  ln -s $FROM $TO
done
