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


DEMO_PROMPT=$PROMPT_NODE2_POD2

info "I am in the pod2 namespace on node2"

pei "ip netns exec pod2 ip addr add 10.1.2.2/16 dev veth-ns"
pei "ip netns exec pod2 ip link set veth-ns up"
pei "ip netns exec pod2 ip link set lo up"
pei "ip netns exec pod2 ip route add default via 10.1.2.254"

DEMO_PROMPT=$PROMPT_NODE2

comment "We are on node2. Check the physical IP"
pe "ip a show eth0"

info "Enter in the namespace to configure it"

ip netns exec pod2 bash _node2_ns.sh

comment "Now, setup the VXLAN on node2 using multicast group 239.1.1.1"
pe "ip link add vxlan0 type vxlan id 1 group 239.1.1.1 dev eth0 dstport 4789"

comment "Attach VXLAN to the bridge"
pei "ip link set vxlan0 master br0"
pei "ip link set vxlan0 up"

redirect "Now setup the VXLAN on node1"
cont

info "Enter in the pod2 namespace to check the connectivity"

ip netns exec pod2 bash _node2_ns2.sh

