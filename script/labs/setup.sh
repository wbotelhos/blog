#!/bin/bash

# $1: remote database password

GRAY='\033[0;36m'
GREEN='\033[0;32m'
NO_COLOR='\033[1;0m'

if [ -n "$1" ]; then
  script/database/production_to_development.sh $1
fi

echo -e "\n${GRAY}Dumpping labs slugs...${NO_COLOR}"

bundle exec rake labs:dump

. script/labs/pull.sh
. script/labs/link.sh

echo -e "\n${GREEN}Done!${NO_COLOR}"
