#!/usr/bin/env bash

. /demo/demo-magic.sh
. /demo/util.sh

DEMO_PROMPT="pod2@node2# "

info "I am in the pod2 namespace on node2"

pe "ip addr add 10.1.1.4/24 dev veth-ns"
pei "ip link set veth-ns up"
pei "ip link set lo up"
pei "ip route add default via 10.1.1.10"

info "Check the interfaces in the pod2 namespace"
pe "ip a"

info "I can ping the bridge from the namespace"
pe "ping -c 3 10.1.1.10"

info "Try to ping the pod1 namespace from node2"
pe "ping -c 3 10.1.1.2"

error "It fails !"

info "Go back to the main namespace of node2"
pe_as "exit" "sleep 1"
