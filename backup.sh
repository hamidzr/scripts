#!/bin/bash

# backups stuff.
# require a minio server

timestamp=_$(date +"%Y-%m-%d")

tar -czvf /tmp/datasets$timestamp.tgz ~/datasets 
gpg -c /tmp/datasets$timestamp.tgz
mc cp /tmp/datasets$timestamp.tgz.gpg nb/test/datasets$timestamp.tgz.gpg
rm /tmp/datasets$timestamp.tgz /tmp/datasets$timestamp.tgz.gpg
