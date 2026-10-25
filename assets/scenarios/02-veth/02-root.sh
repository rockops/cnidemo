#!/bin/bash

########################
# include the magic
########################

TOP=$(cd $(dirname $0) && pwd)

. $TOP/../demo-magic.sh
. $TOP/../util.sh

sudo sleep 1
# hide the evidence
clear

DEMO_PROMPT=$PROMPT_NODE

info "I am in the node"

comment "Create the veth pair"
pe "sudo ip link add veth-host type veth peer name veth-ns"

comment "Add one end of the veth pair to the namespace"
pei "sudo ip link set veth-ns netns ns1"

comment "Assign an IP to the host side of the veth pair"
pei "sudo ip addr add 10.0.0.10/24 dev veth-host"

comment "Bring the interface up"
pei "sudo ip link set veth-host up"

comment "Assign an IP to the namespace side of the veth pair"
pei "sudo ip netns exec ns1 ip addr add 10.0.0.1/24 dev veth-ns"

comment "Bring the interface up"
pei "sudo ip netns exec ns1 ip link set veth-ns up"

sudo ip netns exec ns1 ip link set lo up


comment "One end of the veth pair is host"
pe "ip -br a show | grep -E 'veth-ns|veth-host'"


redirect "Check in the network namespace"

cont

redirect "Ping the namespace from the host"
pe "ping -c 3 10.0.0.1"

comment "Server running in the namespace is now reachable"

pe "curl -m 2 http://10.0.0.1:8080/Hello-from-host || true"

sudo pkill -f echo_server.py 2>/dev/null || true

