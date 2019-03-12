#!/bin/bash
server=$1

/usr/sbin/sshuttle --dns -r $server 0/0 -x 192.168.1.0/24
