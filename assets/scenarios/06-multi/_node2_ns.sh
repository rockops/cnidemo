#!/usr/bin/env bash

. /demo/demo-magic.sh
. /demo/util.sh

DEMO_PROMPT=$PROMPT_NODE2_POD2

info "I am in the pod2 namespace on node2"

pei "ip addr add 10.1.2.2/16 dev veth-ns"
pei "ip link set veth-ns up"
pei "ip link set lo up"
pei "ip route add default via 10.1.2.254"

info "Check the interfaces in the pod2 namespace"
pei "ip a"

info "I can ping the bridge from the namespace"
pe "ping -c 3 10.1.2.254"

info "Try to ping the pod1 namespace from node2"
pe "ping -c 3 10.1.1.1"

error "It fails !"

info "Go back to the main namespace of node2"
pe_as "exit" "sleep 1"
