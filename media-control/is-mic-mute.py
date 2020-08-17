#!/usr/bin/env python3

## Check if all mics are mute or not

import os

stream = os.popen('pacmd list-sources | grep "muted: no"')
print(1) if len(stream.read()) == 0 else print(0)
