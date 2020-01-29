#!/bin/bash -e

# ./uscisCaseStatus.sh PREFIX NUMBER

# case number format aaa-bb-ccc-ddddd: aaa: location code, bb: year, ccc: workday, dddd: case number for the day

case_number="${1}"

echo "======"
echo "checking case status for ${case_number} at $(date) ($(date +%s))"
echo "======"

curl -s 'https://egov.uscis.gov/casestatus/mycasestatus.do' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' -H 'Sec-Fetch-Site: same-origin' -H 'Sec-Fetch-Mode: navigate' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9,fa-IR;q=0.8,fa;q=0.7' --data "changeLocale=&completedActionsCurrentPage=0&upcomingActionsCurrentPage=0&appReceiptNum=${case_number}&caseStatusSearchBtn=CHECK+STATUS" --compressed | pup 'form .appointment-sec p text{}'
