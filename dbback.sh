#!/bin/bash
user=$1
pass=$2
dbname=$3
destination=$4
alert_email=secret@gmail.com
if [ -z "$destination" -a "$destination" != " " ]
then
        echo 'pass dbname and destination'
        exit 1
fi
absoluteFile=$destination"$dbname"_`date -I`.sql
mysqldump --opt -u $user -p$pass $dbname > $absoluteFile
gzip $absoluteFile
ls -lh $absoluteFile.gz && mkdir -p ~/hlog/ && echo "$dbname backedup at `date`: $absoluteFile.gz" >> ~/hlog/db_backup_log.log
echo "$dbname backedup at `date`: located at $absoluteFile.gz" | mutt -a "$absoluteFile.gz" -s "DBBackup $dbname `date -I`" -- $alert_email &
