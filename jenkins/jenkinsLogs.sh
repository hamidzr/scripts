#!/bin/bash

pr=$1
run=$2
pipeline_name=determined-webui-tests

# provide the contents of AWSELBAuthSessionCookie-0 cookie from an authenticated Jenkins page.
session_cookie=$(cat ./COOKIE)

curl -q "https://jenkins.determined.ai/blue/rest/organizations/jenkins/pipelines/$pipeline_name/branches/PR-$pr/runs/$run/log/?start=0" -H "cookie: AWSELBAuthSessionCookie-0=$session_cookie;" --compressed
