#!/bin/bash

# depends on pup

# prints out glassdoor reviews for a company
# in https://www.glassdoor.com/Interview/Triplebyte-Interview-Questions-E1090305_P$i.htm id: Triplebyte-Interview-Questions-E1090305

companyId=$1
maxPages=$2

curl -s "https://www.glassdoor.com/Interview/${companyId}.htm" | pup 'ol.empReviews .description text{}'
for i in $(seq 2 $maxPages)
do
  echo $i
  curl -s "https://www.glassdoor.com/Interview/${companyId}_P$i.htm" | pup 'ol.empReviews .description text{}'
done

