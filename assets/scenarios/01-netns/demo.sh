#!/bin/bash

########################
# include the magic
########################

TOP=$(cd $(dirname $0) && pwd)

. $TOP/../demo-magic.sh
. $TOP/../util.sh

DEMO_PROMPT=$PROMPT_NODE

sudo sleep 1
# hide the evidence
clear

# Clean up any leftover resources from previous runs
sudo pkill -f echo_server.py 2>/dev/null || true
sudo ip netns delete ns1 2>/dev/null || true

comment "First, create a new network namespace: ns1"
pe "sudo ip netns add ns1"

comment "Display the network interfaces on the main host"
pe "ip a"

comment "Run a shell in the new namespace"
pe_as "sudo ip netns exec ns1 bash" "sudo ip netns exec ns1 bash _demo.sh"

DEMO_PROMPT=$PROMPT_NODE

comment "We are back on the main host!" \
        "The echo server is still running inside ns1 on" \
        "its localhost:8080." \
        "Is the 8080 port listening ?"

pe "ss -anp | grep 8080"

comment "Let's try to access localhost:8080 from the main host:"
pe "curl -m 2 http://localhost:8080/Hello-from-host || true"

info "Connection refused!" \
     "The localhost (127.0.0.1) of the namespace ns1 is completely" \
     "isolated from the localhost of the main host."

info "End of the demo"
