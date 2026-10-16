#!/usr/bin/env bash

. /demo/demo-magic.sh
. /demo/util.sh

DEMO_PROMPT=$PROMPT_NODE1

info "I am on node1. Create the namespace, veth and bridge with a dedicated subnet (10.1.1.0/24)"

cd /demo/08-routing

echo ""
echo "> namespace"
pei "ip netns add pod1"

echo ""
echo "> bridge"
pei "ip link add br0 type bridge"
pei "ip addr add 10.1.1.254/24 dev br0"
pei "ip link set br0 up"

echo ""
echo "> veth pair"
pei "ip link add veth-host type veth peer name veth-ns"

echo ""
echo "> move veth-ns to the pod namespace"
pei "ip link set veth-ns netns pod1"

echo ""
echo "> attach host veth to bridge"
pei "ip link set veth-host master br0"
pei "ip link set veth-host up"

info "Configure pod1 namespace"

DEMO_PROMPT=$PROMPT_NODE1_POD1
pei "ip netns exec pod1 ip addr add 10.1.1.1/24 dev veth-ns"
pei "ip netns exec pod1 ip link set veth-ns up"
pei "ip netns exec pod1 ip link set lo up"
pei "ip netns exec pod1 ip route add default via 10.1.1.254"

DEMO_PROMPT=$PROMPT_NODE1

comment "We are on node1. Check the physical IP"
pe "ip a show eth0"

redirect "Now create a namespace on node2 and try to ping node1"
cont

comment "Back on node1: add a route to node2's pod subnet (10.1.2.0/24) via node2's IP (172.17.0.3)"
pe "ip route add 10.1.2.0/24 via 172.17.0.3 dev eth0"

comment "Ensure IP forwarding is enabled on node1"
pei "sysctl -w net.ipv4.ip_forward=1"

comment "Display the routing table on node1"
pe "ip route"

redirect "Go to node2 to test ping from pod2 to pod1"
cont

comment "Test connectivity in the other direction: ping from pod1 to pod2 (10.1.2.2)"
pe "ip netns exec pod1 ping -c 3 10.1.2.2"

info "L3 routed connection between node1 and node2 is fully working !"
