#!/usr/bin/env python3

"""
Find the base commit that {target} was branched off of given a src {branch}.
"""

import sys
import subprocess

branch = sys.argv[1] if len(sys.argv) > 1 else 'upstream/master'

def execute(cmd: str):
    # print(cmd)
    proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    proc.wait()
    stdout, _ = proc.communicate()
    return stdout.decode('utf-8')

hashes_src = execute(f"git log {branch} --oneline | cut -d ' ' -f 1").split('\n')
hashes_target = execute("git log --oneline | cut -d ' ' -f 1").split('\n')

# print(branch, len(hashes_src), len(hashes_target))
src_dict = {}
for h in hashes_src:
    src_dict[h] = True

# print(src_dict)
# print(hashes_target[:10])

for h in hashes_target:
    if h in src_dict:
        print(h)
        break
