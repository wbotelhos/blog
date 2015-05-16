#!/bin/bash

CREDENTIALS='user@wbotelhos.com'
DATABASE='wbotelhos'
FILE_SQL="wbotelhos_`date +%Y-%m-%d_%H-%M-%S`.sql"
FILE_TAR="${FILE_SQL}.tar.gz"
SSH_KEY=~/.ssh/blog
USERNAME='root'

read -sp 'Database production password: ' PASSWORD

if [ "${PASSWORD}" == '' ]; then
  echo -e "${RED}Password missing!${NO_COLOR}\n" && exit 1
fi

ssh -i $SSH_KEY $CREDENTIALS "cd /tmp && mysqldump -u $USERNAME -p'${PASSWORD}' ${DATABASE}_production > $FILE_SQL && tar zcf $FILE_TAR $FILE_SQL" && \
scp -i $SSH_KEY ${CREDENTIALS}:/tmp/${FILE_TAR} /tmp && \
tar zxf /tmp/${FILE_TAR} -C /tmp && mysql -u $USERNAME ${DATABASE}_development < /tmp/${FILE_SQL}
