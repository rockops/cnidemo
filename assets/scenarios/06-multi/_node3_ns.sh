#!/usr/bin/env bash

. /demo/demo-magic.sh
. /demo/util.sh

DEMO_PROMPT=$PROMPT_NODE3_POD3

info "I am in the pod3 namespace on node3"

comment "Ping pod1 on node1 (10.1.1.1)"
pe "ping -c 3 10.1.1.1"

comment "Ping pod2 on node2 (10.1.2.2)"
pe "ping -c 3 10.1.2.2"

info "Connectivity verified across all 3 nodes without changing Node1 or Node2!"
