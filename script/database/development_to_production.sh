#!/bin/bash

# $1: remote database password

. script/colors.sh

FILE_SQL="wbotelhos_local_`date +%Y-%m-%d_%H-%M-%S`.sql"
FILE_TAR="${FILE_SQL}.tar.gz"

echo -e "\n${GRAY}Dumpping development database...${NO_COLOR}"
cd /tmp && mysqldump -u root wbotelhos_development > $FILE_SQL && tar zcf $FILE_TAR $FILE_SQL && rm -rf $FILE_SQL

echo -e "\n${GRAY}Backuping online database...${NO_COLOR}"
ssh -i ~/.ssh/wbotelhos.pem ubuntu@wbotelhos.com "mkdir -p ~/backup && cd ~/backup && mysqldump -u root -p'${1}' wbotelhos_production > $FILE_SQL && tar zcf $FILE_TAR $FILE_SQL && rm -rf $FILE_SQL"

echo -e "\n${GRAY}Sending to server and applying it...${NO_COLOR}"
scp -i ~/.ssh/wbotelhos.pem /tmp/${FILE_TAR} ubuntu@wbotelhos.com:/tmp && \
ssh -i ~/.ssh/wbotelhos.pem ubuntu@wbotelhos.com "cd /tmp && tar zxf $FILE_TAR && mysql -u root -p'${1}' wbotelhos_production < $FILE_SQL"

echo -e "\n${GREEN}Done!${NO_COLOR}"
