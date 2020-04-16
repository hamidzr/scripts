#!/bin/bash

# fetch jenkins logs:
# pass in a PR number to get all the logs for a certain PR
# do not provide a pr number to get logs for all open PRs.

pipline_name=$1
requested_pr=$2

function check_all_runs {
  local pr=$1
  run=1
  while true; do
    jenkins-logs.sh $pipline_name $pr $run || break
    run=$((run+1))
  done;
  echo "reached the last run ($run) for pr_$pr"
}

if [ -z ${requested_pr} ]; then
  prs=$(hub pr list -f %I%n)
  for pr in $prs; do
    check_all_runs $pr
  done;
else
  check_all_runs $requested_pr
fi
