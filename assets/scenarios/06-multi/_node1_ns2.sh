#!/usr/bin/env bash

. /demo/demo-magic.sh
. /demo/util.sh

DEMO_PROMPT=$PROMPT_NODE1_POD1

info "I am in the pod1 namespace on node1" "I can ping the pod2 on node2"
pe "ping -c 3 10.1.2.2"
