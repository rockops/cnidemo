#!/usr/bin/env bash

TOP=$(cd $(dirname $0) && pwd)

. $TOP/../demo-magic.sh
. $TOP/../util.sh

DEMO_PROMPT=$PROMPT_NS1

info "I am in the network namespace: ns1"

comment "Display the network interfaces in the current namespace"
pe "ip a"

