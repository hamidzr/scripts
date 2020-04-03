#!/bin/bash

pr=$1
run=$2
pipeline_name=determined-webui-tests

# provide the contents of AWSELBAuthSessionCookie-0 cookie from an authenticated Jenkins page.
session_cookie=$(cat $HOME/.config/JENKINS_COOKIE)

resp=$(curl -s "https://jenkins.determined.ai/blue/rest/organizations/jenkins/pipelines/$pipeline_name/branches/PR-$pr/runs/$run/log/?start=0" -H "cookie: AWSELBAuthSessionCookie-0=$session_cookie;" --compressed 2>&1)

echo "${resp}" | grep -E "Run $run not found in|title.*302 Found" &>/dev/null && exit 1

echo "## begining of logs for pr_$pr run_$run ##"
echo "${resp}"
echo "## end of logs for pr_$pr run_$run ##"


exit 0
