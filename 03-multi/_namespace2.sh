#!/usr/bin/env bash

. /home/ben/share_CNI/demo-magic.sh
. /home/ben/share_CNI/util.sh

DEMO_PROMPT="ns1# "

info "I am in the network namespace: ns1"

comment "Display the network interfaces in the current namespace"
pe "ip a"

comment "ping ns2"
pe "ping -c 3 10.0.0.3" 

comment "ping the bridge"
pe "ping -c 3 10.0.0.254"
