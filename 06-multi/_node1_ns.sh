#!/usr/bin/env bash

. /demo/demo-magic.sh
. /demo/util.sh

DEMO_PROMPT="pod1@node1# "

info "I am in the pod1 namespace on node1"

pe "ip addr add 10.1.1.2/24 dev veth-ns"
pei "ip link set veth-ns up"
pei "ip link set lo up"
pei "ip route add default via 10.1.1.1"

info "Check the interfaces in the pod1 namespace"
pe "ip a"

info "I can ping the bridge from the namespace"
pe "ping -c 3 10.1.1.1"

info "Go back to the main namespace of node1"
pe_as "exit" "sleep 1"