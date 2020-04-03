#!/bin/bash -e

# facilitate running n long running and blocking jobs together on the same terminal

delay=$1

# trap 'kill $(jobs -p)' EXIT
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

for arg in "${@:2}"; do
  echo "## starting ${arg} ##"
  $arg &
  sleep $delay
done

sleep infinity


