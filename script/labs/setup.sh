#!/bin/bash

# $1: remote database password

. script/colors.sh

if [ -n "$1" ]; then
  script/database/production_to_development.sh $1
fi

echo -e "\n${GRAY}Dumpping labs slugs...${NO_COLOR}"
bundle exec rake labs:dump

. script/labs/pull.sh
. script/labs/link.sh

echo -e "\n${GREEN}Done!${NO_COLOR}"
