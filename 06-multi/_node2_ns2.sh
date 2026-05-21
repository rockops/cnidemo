#!/usr/bin/env bash

. /demo/demo-magic.sh
. /demo/util.sh

DEMO_PROMPT="pod2@node2# "

info "I am in the pod2 namespace on node2"

info "I can now ping the pod1 namespace from node2"
pe "ping -c 3 10.1.1.2"
