#!/bin/bash

# fetch jenkins logs from a pr $pr, test $pipeline_name and run $run

pipeline_name=$1
pr=$2
run=$3

# provide the contents of AWSELBAuthSessionCookie-0 cookie from an authenticated Jenkins page.
session_cookie="${HOME}/.config/JENKINS_COOKIE"

resp=$(curl -s "https://jenkins.determined.ai/blue/rest/organizations/jenkins/pipelines/$pipeline_name/branches/PR-$pr/runs/$run/log/?start=0" -H "cookie: AWSELBAuthSessionCookie-0=$(cat $session_cookie);" --compressed 2>&1)

fail_msg="failed. check the cookie and inputs. pr: $pr, run: $run, pipeline: $pipeline_name"
echo "${resp}" | grep -E "Run $run not found in|title.*302 Found" &>/dev/null && echo $fail_msg && exit 1

echo "## begining of logs for pr_$pr run_$run ##"
echo "${resp}"
echo "## end of logs for pr_$pr run_$run ##"


exit 0
