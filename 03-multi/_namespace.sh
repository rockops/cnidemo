#!/bin/bash

########################
# include the magic
########################
. /home/ben/share_CNI/demo-magic.sh
. /home/ben/share_CNI/util.sh

DEMO_PROMPT="ns2# "

sudo sleep 1
# hide the evidence
clear

info "I am in the network namespace: ns2"

comment "Configure the second namespace interface"
pe "ip addr add 10.0.0.3/24 dev veth-ns2"
pei "ip link set veth-ns2 up"
pei "ip link set lo up"

comment "Display the interfaces in the second namespace"
pe "ip a"

comment "ping from the first namespace to the second namespace"
pe "ping -c 3 10.0.0.2"

error "It fails !" "We need to create a bridge in the root namespace"
cont

comment "Now that we have the bridge, we can ping between the 2 namespaces"
pe "ping -c 3 10.0.0.2"

comment "Switch to the first namespace"
pe_as "sudo ip netns exec ns1 bash" "sudo ip netns exec ns1 bash _namespace2.sh"

