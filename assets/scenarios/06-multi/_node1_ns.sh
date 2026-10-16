#!/usr/bin/env bash

. /demo/demo-magic.sh
. /demo/util.sh

DEMO_PROMPT=$PROMPT_NODE1_POD1

info "I am in the pod1 namespace on node1"

pei "ip addr add 10.1.1.1/16 dev veth-ns"
pei "ip link set veth-ns up"
pei "ip link set lo up"
pei "ip route add default via 10.1.1.154"

info "Go back to the main namespace of node1"
