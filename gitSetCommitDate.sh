#!/bin/bash

targetCommit=$1

echo "Setting commit $1 date to $2"
echo "Edit the first commit in your editor."
read -r -p "Are you sure? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        git rebase $targetCommit^ -i
        ;;
    *)
        exit 1
        ;;
esac

# desiredDate="Mon 20 Aug 2018 20:19:19 PST"
desiredDate=$2

GIT_COMMITTER_DATE="$desiredDate" git commit --amend --no-edit --date "$desiredDate"
