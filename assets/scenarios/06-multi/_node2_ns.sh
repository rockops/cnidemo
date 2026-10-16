#!/usr/bin/env bash

. /demo/demo-magic.sh
. /demo/util.sh

DEMO_PROMPT=$PROMPT_NODE2_POD2

info "Try to ping the pod1 namespace from node2"
pe "ping -c 3 10.1.1.1"

error "It fails !"

info "Go back to the main namespace of node2"
pe_as "exit" "sleep 1"
