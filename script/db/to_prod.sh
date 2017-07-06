#!/bin/bash

CREDENTIALS='user@wbotelhos.com'
DATABASE='blogy'
FILE_SQL="blogy_development_`date +%Y-%m-%d_%H-%M-%S`.sql"
FILE_TAR="${FILE_SQL}.tar.gz"
SSH_KEY=~/.ssh/id_rsa
USERNAME='root'

read -sp 'Database production password: ' PASSWORD

if [ "${PASSWORD}" == '' ]; then
  echo -e "${RED}Password missing!${NO_COLOR}\n" && exit 1
fi

cd /tmp && mysqldump -u $USERNAME ${DATABASE}_development > $FILE_SQL && tar zcf $FILE_TAR $FILE_SQL && rm -rf $FILE_SQL && \
ssh -i $SSH_KEY $CREDENTIALS "cd /tmp && mysqldump -u $USERNAME -p'${PASSWORD}' ${DATABASE}_production > $FILE_SQL && tar zcf $FILE_TAR $FILE_SQL" && \
scp -i $SSH_KEY /tmp/${FILE_TAR} $CREDENTIALS:/tmp && \
ssh -i $SSH_KEY $CREDENTIALS "cd /tmp && tar zxf $FILE_TAR && mysql -u $USERNAME -p'${PASSWORD}' ${DATABASE}_production < ${FILE_SQL}"
