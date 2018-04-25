#!/bin/bash

DATE=$(date "+%Y%m%d%H%M%S")

mkdir -p /var/www/blog/releases

mv /var/www/blog/codedeploy /var/www/blog/releases/${DATE}

ln -nfs /var/www/blog/releases/${DATE} /var/www/blog/current
