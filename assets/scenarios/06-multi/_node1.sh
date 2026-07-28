#!/usr/bin/env bash

. /demo/demo-magic.sh
. /demo/util.sh

DEMO_PROMPT=$PROMPT_NODE1

info "I am on node1. Create the namespace, veth and bridge"

cd /demo/06-multi

echo ""
echo "> namespace"
pei "ip netns add pod1"

echo ""
echo "> bridge"
pei "ip link add br0 type bridge"
pei "ip addr add 10.1.1.154/16 dev br0"
pei "ip link set br0 up"

echo ""
echo "> veth"
pei "ip link add veth-host type veth peer name veth-ns"

echo ""
echo "> move veth-ns to the pod namespace"
pei "ip link set veth-ns netns pod1"

echo ""
echo "> attach host veth to bridge"
pei "ip link set veth-host master br0"
pei "ip link set veth-host up"

info "Enter in the namespace to configure it"

ip netns exec pod1 bash _node1_ns.sh

comment "We are back in node1. Check the interfaces"
pe "ip a"

comment "We can ping the pod1 namespace from the node"
pe "ping -c 3 10.1.1.1"

redirect "Now create a namespace on node2"
cont

comment "Back on node 1" "Setup the VXLAN on node 1"
pe "ip link add vxlan0 type vxlan id 1 local 172.17.0.2 remote 172.17.0.3 dstport 4789"

comment "Attach VXLAN to the bridge"
pe "ip link set vxlan0 master br0"
pei "ip link set vxlan0 up"

comment "Enter pod1 to check the connectivity"
ip netns exec pod1 bash _node1_ns2.sh
