#!/usr/bin/env bash

. /demo/demo-magic.sh
. /demo/util.sh

DEMO_PROMPT=$PROMPT_NODE2

info "I am on node2. Create the namespace, veth and bridge"

cd /demo/06-multi

echo ""
pei "ip netns add pod2"
pei "ip link add br0 type bridge"
pei "ip addr add 10.1.2.254/16 dev br0"
pei "ip link set br0 up"
pei "ip link add veth-host type veth peer name veth-ns"
pei "ip link set veth-ns netns pod2"
pei "ip link set veth-host master br0"
pei "ip link set veth-host up"

info "Enter in the namespace to configure it"

ip netns exec pod2 bash _node2_ns.sh

comment "We are back to node2 in root namespace." "We can ping the pod2 namespace from the host"
pe "ping -c 3 10.1.2.2"

comment "Check the network interfaces"
pe "ip a"

comment "Now, setup the VXLAN from node2 to node1"
pe "ip link add vxlan0 type vxlan id 1 local 172.17.0.3 remote 172.17.0.2 dstport 4789"

comment "Attach VXLAN to the bridge"
pe "ip link set vxlan0 master br0"
pei "ip link set vxlan0 up"

redirect "Now setup the VXLAN on node1"
cont

info "Enter in the pod2 namespace to check the connectivity"

ip netns exec pod2 bash _node2_ns2.sh

