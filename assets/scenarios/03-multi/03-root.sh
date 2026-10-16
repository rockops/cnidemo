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

comment "Create a new network namespace"
pe "sudo ip netns add ns2"

comment "Create a second veth pair"
pei "sudo ip link add veth-host2 type veth peer name veth-ns2"
pei "sudo ip addr add 10.0.0.20/24 dev veth-host2"
pei "sudo ip link set veth-host2 up"

comment "Attach veth-ns2 to the second namespace"
pei "sudo ip link set veth-ns2 netns ns2"

comment "Configure the second namespace interface"
pei "sudo ip netns exec ns2 ip addr add 10.0.0.2/24 dev veth-ns2"
pei "sudo ip netns exec ns2 ip link set veth-ns2 up"
pei "sudo ip netns exec ns2 ip link set lo up"




redirect "Try to ping ns1 from ns2"
cont

comment "Create the bridge"
pe "sudo ip link add br0 type bridge"
pei "sudo ip addr add 10.0.0.254/24 dev br0"
pei "sudo ip link set br0 up"

comment "Attach the 2 interfaces to the bridge"
pe "sudo ip addr del 10.0.0.10/24 dev veth-host"
pei "sudo ip addr del 10.0.0.20/24 dev veth-host2"
pei "sudo ip link set veth-host master br0"
pei "sudo ip link set veth-host2 master br0"

comment "Display the bridge interfaces"
pe "(ip a show br0; ip a show master br0) | grep -E 'br0|veth-host|veth-host2'"

redirect "Enter the second namespace to check the connectivity"
cont

comment "You can ping both namespaces from the host"
pe "ping -c 2 10.0.0.1"
pei "ping -c 2 10.0.0.2"
