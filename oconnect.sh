#!/bin/bash
ovpn_path=/home/hmd/ovpn.conf
openvpn $ovpn_path & 
disown
