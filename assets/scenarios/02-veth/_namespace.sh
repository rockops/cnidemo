#!/bin/bash

########################
# include the magic
########################

TOP=$(cd $(dirname $0) && pwd)

. $TOP/../demo-magic.sh
. $TOP/../util.sh

DEMO_PROMPT=$PROMPT_NS1

sudo sleep 1
# hide the evidence
clear

info "I am in the network namespace: ns1"

comment "One end of the veth pair is now in the namespace"
#pe "ip -br a show | grep -E 'veth-ns|veth-host'"
pe "ip a"

comment "Ping the host"
pe "ping -c 3 10.0.0.10"

redirect "Now you can ping the namespace from the host"
