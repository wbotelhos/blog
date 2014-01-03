#!/bin/bash

echo -e "\n${GRAY}Linking labs into plublic directory...${NO_COLOR}"

for LAB in "${LABS[@]}"; do
  FROM=~/workspace/"${LAB}"
  TO="public/${LAB}"

  if [ -L "$TO" ]; then
    rm $TO
  fi

  ln -s $FROM $TO
done
