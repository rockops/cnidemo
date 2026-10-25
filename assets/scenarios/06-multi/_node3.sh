#!/usr/bin/env bash

. /demo/demo-magic.sh
. /demo/util.sh

DEMO_PROMPT=$PROMPT_NODE3

info "I am on node3. Create the namespace, veth and bridge"

cd /demo/06-multi

echo ""
pei "ip netns add pod3"
pei "ip link add br0 type bridge"
pei "ip addr add 10.1.3.254/16 dev br0"
pei "ip link set br0 up"
pei "ip link add veth-host type veth peer name veth-ns"
pei "ip link set veth-ns netns pod3"
pei "ip link set veth-host master br0"
pei "ip link set veth-host up"

DEMO_PROMPT=$PROMPT_NODE3_POD3

info "I am in the pod3 namespace on node3"

pei "ip netns exec pod3 ip addr add 10.1.3.3/16 dev veth-ns"
pei "ip netns exec pod3 ip link set veth-ns up"
pei "ip netns exec pod3 ip link set lo up"
pei "ip netns exec pod3 ip route add default via 10.1.3.254"

DEMO_PROMPT=$PROMPT_NODE3

comment "We are on node3. Check the physical IP"
pe "ip a show eth0"

comment "Join the existing overlay with the same multicast group 239.1.1.1"
pe "ip link add vxlan0 type vxlan id 1 group 239.1.1.1 dev eth0 dstport 4789"

comment "Attach VXLAN to the bridge"
pei "ip link set vxlan0 master br0"
pei "ip link set vxlan0 up"

info "Enter in the pod3 namespace to test connectivity to pod1 and pod2"

ip netns exec pod3 bash _node3_ns.sh
