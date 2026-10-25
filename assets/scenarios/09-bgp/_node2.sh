#!/usr/bin/env bash

. /demo/demo-magic.sh
. /demo/util.sh

DEMO_PROMPT=$PROMPT_NODE2

info "I am on node2. Setup namespace, bridge and veth"

cd /demo/09-bgp

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
pei "ip link set veth-ns netns pod2"
pei "ip link set veth-host master br0"
pei "ip link set veth-host up"

info "Configure pod2 namespace"

DEMO_PROMPT=$PROMPT_NODE2_POD2
pei "ip netns exec pod2 ip addr add 10.1.2.2/24 dev veth-ns"
pei "ip netns exec pod2 ip link set veth-ns up"
pei "ip netns exec pod2 ip link set lo up"
pei "ip netns exec pod2 ip route add default via 10.1.2.254"

DEMO_PROMPT=$PROMPT_NODE2
pei "sysctl -w net.ipv4.ip_forward=1"

comment "Check node2 physical IP"
pe "ip a show eth0"

DEMO_PROMPT=$PROMPT_NODE2_POD2
info "Try to ping pod1 (10.1.1.1) from pod2 before starting BGP"
pe "ip netns exec pod2 ping -c 3 10.1.1.1"

error "It fails ! Node2 has no route to reach the 10.1.1.0/24 subnet"

DEMO_PROMPT=$PROMPT_NODE2
comment "Inspect the BIRD BGP configuration for node2"
pe "cat bird_node2.conf"

comment "Start the BIRD routing daemon on node2"
pe "bird -c bird_node2.conf -s /run/bird.ctl"
sleep 2

comment "Check BGP protocol status"
pe "birdc -s /run/bird.ctl show protocols"

comment "Inspect the routes known to BIRD"
pe "birdc -s /run/bird.ctl show route"

comment "Check the Linux kernel routing table on node2"
comment "Notice 'proto bird': 10.1.1.0/24 was learned" "dynamically via BGP !"
pe "ip route"

DEMO_PROMPT=$PROMPT_NODE2_POD2
info "Now test ping again from pod2 to pod1 (10.1.1.1)"
pe "ip netns exec pod2 ping -c 3 10.1.1.1"
DEMO_PROMPT=$PROMPT_NODE2

info "Success ! Route was learned and populated" "dynamically by BGP"
