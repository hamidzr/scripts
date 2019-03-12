#!/bin/bash

dev=$1

sudo ip link set $dev down
sudo macchanger -r $dev
sudo ip link set $dev up
