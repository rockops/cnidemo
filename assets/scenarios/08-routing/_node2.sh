#!/usr/bin/env bash

. /demo/demo-magic.sh
. /demo/util.sh

DEMO_PROMPT=$PROMPT_NODE2

info "I am on node2. Create the namespace, veth" "and bridge with a dedicated subnet (10.1.2.0/24)"

cd /demo/08-routing

echo ""
echo "> namespace"
pei "ip netns add pod2"

echo ""
echo "> bridge"
pei "ip link add br0 type bridge"
pei "ip addr add 10.1.2.254/24 dev br0"
pei "ip link set br0 up"

echo ""
echo "> veth pair"
pei "ip link add veth-host type veth peer name veth-ns"

echo ""
echo "> move veth-ns to the pod namespace"
pei "ip link set veth-ns netns pod2"

echo ""
echo "> attach host veth to bridge"
pei "ip link set veth-host master br0"
pei "ip link set veth-host up"

info "Configure pod2 namespace"

DEMO_PROMPT=$PROMPT_NODE2_POD2
pei "ip netns exec pod2 ip addr add 10.1.2.2/24 dev veth-ns"
pei "ip netns exec pod2 ip link set veth-ns up"
pei "ip netns exec pod2 ip link set lo up"
pei "ip netns exec pod2 ip route add default via 10.1.2.254"

DEMO_PROMPT=$PROMPT_NODE2

comment "We are on node2. Check the physical IP"
pe "ip a show eth0"

info "Try to ping pod1 (10.1.1.1) from pod2 before configuring routing"
DEMO_PROMPT=$PROMPT_NODE2_POD2
pe "ip netns exec pod2 ping -c 1 10.1.1.1"
DEMO_PROMPT=$PROMPT_NODE2

error "It fails ! Node2 has no route to reach" "the 10.1.1.0/24 subnet"

comment "In a Layer 3 CNI, we route pod subnets" "instead of using a VXLAN overlay"
comment "Add a route to node1's pod subnet (10.1.1.0/24)" "via node1's IP (172.17.0.2)"
pe "ip route add 10.1.1.0/24 via 172.17.0.2 dev eth0"

comment "Display the routing table on node2"
pe "ip route"

redirect "Now add the return route on node1"
cont

DEMO_PROMPT=$PROMPT_NODE2_POD2
info "Routes are configured on both nodes!" "Test ping again from pod2 to pod1"
pe "ip netns exec pod2 ping -c 3 10.1.1.1"
DEMO_PROMPT=$PROMPT_NODE2


info "Success ! Packets are routed at Layer 3" "without any overlay encapsulation"
