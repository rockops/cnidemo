#!/bin/bash

########################
# include the magic
########################
. /home/ben/share_CNI/demo-magic.sh
. /home/ben/share_CNI/util.sh

DEMO_PROMPT="ns1# "

sudo sleep 1
# hide the evidence
clear

info "I am in the network namespace: ns1"

comment "Display the network interfaces in the current namespace"
pe "ip a"

comment "Assign an IP to the namespace side of the veth pair"
pe "ip addr add 10.0.0.2/24 dev veth-ns"

comment "Bring the interface up"
pe "ip link set veth-ns up"

sudo ip netns exec ns1 ip link set lo up

comment "Display the network interfaces in the current namespace"
pe "ip a"

comment "Ping the host"
pe "ping -c 3 10.0.0.1"

redirect "Now you can ping the namespace from the host"
