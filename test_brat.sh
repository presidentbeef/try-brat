#!/bin/bash
cd /var/www/try-brat/tmp/brat
git fetch
git reset --hard origin/master
touch stdlib/*.brat

sh ./build.sh &> output

if [ $? -ne "0" ]
then
  ln -f -s /var/www/try-brat/public/images/red.png /var/www/try-brat/public/images/status.png
else
  ln -f -s /var/www/try-brat/public/images/green.png /var/www/try-brat/public/images/status.png
fi

tail -n 1 output > status
rm output
