#!/bin/bash -x

prs=$(hub pr list -f %I%n)

for pr in $prs; do
  jenkinsLogs.sh $pr 1
done;
