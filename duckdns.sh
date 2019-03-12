#!/usr/bin/env bash
DUCKPATH=$HOME/logs/duckdns
DOMAINS=$1
TOKEN=$2

curl -sSv "https://www.duckdns.org/update?domains=${DOMAINS}&token=${TOKEN}&ip=" \
  2>> ${DUCKPATH}/stderr.log \
   >> ${DUCKPATH}/stdout.log
printf ' - ' >> ${DUCKPATH}/stdout.log
date >> ${DUCKPATH}/stdout.log
