#! /bin/bash

# checks internet speed and logs it into a dir
# makesure speedtest is installed
LOGPATH=$HOME/logs/speedtest

echo '###############'
speedtest \
  2>> ${LOGPATH}/stderr.log \
   >> ${LOGPATH}/stdout.log

printf ' - ' >> ${LOGPATH}/stdout.log
date >> ${LOGPATH}/stdout.log
