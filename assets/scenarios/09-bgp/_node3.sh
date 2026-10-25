#!/usr/bin/env bash

. /demo/demo-magic.sh
. /demo/util.sh

DEMO_PROMPT=$PROMPT_NODE3

info "I am on node3. Setup namespace, bridge and veth"

cd /demo/09-bgp

echo ""
echo "> namespace"
pei "ip netns add pod3"

echo ""
echo "> bridge"
pei "ip link add br0 type bridge"
pei "ip addr add 10.1.3.254/24 dev br0"
pei "ip link set br0 up"

echo ""
echo "> veth pair"
pei "ip link add veth-host type veth peer name veth-ns"
pei "ip link set veth-ns netns pod3"
pei "ip link set veth-host master br0"
pei "ip link set veth-host up"

info "Configure pod3 namespace"

DEMO_PROMPT=$PROMPT_NODE3_POD3
pei "ip netns exec pod3 ip addr add 10.1.3.3/24 dev veth-ns"
pei "ip netns exec pod3 ip link set veth-ns up"
pei "ip netns exec pod3 ip link set lo up"
pei "ip netns exec pod3 ip route add default via 10.1.3.254"

DEMO_PROMPT=$PROMPT_NODE3
pei "sysctl -w net.ipv4.ip_forward=1"

comment "Check node3 physical IP"
pe "ip a show eth0"

comment "Inspect the BIRD BGP configuration for node3" "(peers with node1 and node2)"
pe "cat bird_node3.conf"

comment "Start the BIRD routing daemon on node3"
pe "bird -c bird_node3.conf -s /run/bird.ctl"
sleep 2

comment "Check BGP protocol status"
pe "birdc -s /run/bird.ctl show protocols"

comment "Inspect the routes known to BIRD"
pe "birdc -s /run/bird.ctl show route"

comment "Check the Linux kernel routing table on node3"
comment "Notice 'proto bird': 10.1.1.0/24 and 10.1.2.0/24" "were learned dynamically via BGP !"
pe "ip route"

DEMO_PROMPT=$PROMPT_NODE3_POD3
info "Now test ping again from pod3 to pod1 (10.1.1.1)" "and pod2 (10.1.2.2)"
pe "ip netns exec pod3 ping -c 2 10.1.1.1"
pe "ip netns exec pod3 ping -c 2 10.1.2.2"
DEMO_PROMPT=$PROMPT_NODE3

info "Success ! Node3 dynamically joined the cluster" "and full-mesh routing converged !"
