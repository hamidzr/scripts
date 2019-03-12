#!/bin/bash
cat $1 | perl -pe 's/((?<=,)|(?<=^)),/ ,/g;' | column -t -s, | less -S
