#!/bin/bash

## list biggest directories under the current path

depth=${1:-2}


fd --type d . --max-depth=$depth -H | xargs -I{} du -sh "{}" \
    | grep -P '^[\d.]+G' | sort -nk1,1
