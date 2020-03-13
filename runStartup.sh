#!/bin/bash
ip=$(ifconfig enp3s0 | grep 'inet ' | cut -d: -f2 | awk '{ print $2}')
v=$(host "$ip" | awk '{ print $5}')
echo "$ip"
echo "$v"
#hostnamectl set-hostname "$v"
