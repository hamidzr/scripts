#!/bin/bash
# deletes a commit in middle of a branch
# for now it just finds out the previous commit's hash

hash=$1

# TODO how to easily reuse this?
commits=$(git log | grep 'commit ' | grep -oE '[a-z0-9]+$')

# check if the given hash substring is unique
numResults=$(git log | grep 'commit ' | grep -oE '[a-z0-9]+$' | grep -n $hash | wc -l)

if [ $numResults -gt 1 ]; then
  echo "hash $hash matches more than one commit"
  exit 1
fi

# find out the previous commit hash
commitLine=$(git log | grep 'commit ' | grep -oE '[a-z0-9]+$' | grep -n $hash | cut -d ':' -f1)
prevCommitLine=$((commitLine+1))
prevCommit=$(git log | grep 'commit ' | grep -oE '[a-z0-9]+$' | sed -n "${prevCommitLine}p")

echo $prevCommit

# TODO rebase to the prev commit and edit
