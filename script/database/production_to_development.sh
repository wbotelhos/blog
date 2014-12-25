#!/bin/bash

# $1: remote database password

GRAY='\033[0;36m'
GREEN='\033[0;32m'
NO_COLOR='\033[1;0m'

FILE_SQL="wbotelhos_`date +%Y-%m-%d_%H-%M-%S`.sql"
FILE_TAR="${FILE_SQL}.tar.gz"

echo -e "\n${GRAY}Dumpping production database...${NO_COLOR}"
ssh -i ~/.ssh/wbotelhos.pem ubuntu@wbotelhos.com "cd /tmp && mysqldump -u root -p'$1' wbotelhos_production > $FILE_SQL && tar zcf $FILE_TAR $FILE_SQL && rm -rf $FILE_SQL"

echo -e "\n${GRAY}Copying from server...${NO_COLOR}"
scp -i ~/.ssh/wbotelhos.pem ubuntu@wbotelhos.com:/tmp/${FILE_TAR} .

echo -e "\n${GRAY}Applying locally...${NO_COLOR}"
tar zxf $FILE_TAR
mysql -u root wbotelhos_development < $FILE_SQL

echo -e "\n${GREEN}Done!${NO_COLOR}"
