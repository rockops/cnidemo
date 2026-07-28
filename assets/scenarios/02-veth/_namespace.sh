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

comment "Display the network interfaces in the current namespace"
pe "ip a"

comment "Assign an IP to the namespace side of the veth pair"
pe "ip addr add 10.0.0.1/24 dev veth-ns"

comment "Bring the interface up"
pe "ip link set veth-ns up"

sudo ip netns exec ns1 ip link set lo up

comment "Display the network interfaces in the current namespace"
pe "ip a"

comment "Ping the host"
pe "ping -c 3 10.0.0.10"

redirect "Now you can ping the namespace from the host"
