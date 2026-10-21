#!/usr/bin/env bash

. /demo/demo-magic.sh
. /demo/util.sh

DEMO_PROMPT=$PROMPT_NODE1

info "I am on node1. Setup namespace, bridge and veth"

cd /demo/09-bgp

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
pei "ip link set veth-ns netns pod1"
pei "ip link set veth-host master br0"
pei "ip link set veth-host up"

info "Configure pod1 namespace"

DEMO_PROMPT=$PROMPT_NODE1_POD1
pei "ip netns exec pod1 ip addr add 10.1.1.1/24 dev veth-ns"
pei "ip netns exec pod1 ip link set veth-ns up"
pei "ip netns exec pod1 ip link set lo up"
pei "ip netns exec pod1 ip route add default via 10.1.1.254"

DEMO_PROMPT=$PROMPT_NODE1
pei "sysctl -w net.ipv4.ip_forward=1"

comment "Check node1 physical IP"
pe "ip a show eth0"

comment "Inspect the BIRD BGP configuration for node1"
pe "cat bird_node1.conf"

comment "Start the BIRD routing daemon on node1"
pe "bird -c bird_node1.conf -s /run/bird.ctl"
sleep 1

comment "Check BGP protocol status (waiting for node2)"
pe "birdc -s /run/bird.ctl show protocols"

redirect "Now connect to node2 and start its BGP daemon"
cont

comment "Back on node1: check if BGP session is now Established"
pe "birdc -s /run/bird.ctl show protocols"

comment "Check the Linux kernel routing table on node1"
comment "Notice 'proto bird': the route was injected automatically by BGP !"
pe "ip route"

DEMO_PROMPT=$PROMPT_NODE1_POD1
comment "Test reverse ping from pod1 to pod2 (10.1.2.2)"
pe "ip netns exec pod1 ping -c 3 10.1.2.2"
DEMO_PROMPT=$PROMPT_NODE1

info "BGP dynamic route exchange is fully operational !"
