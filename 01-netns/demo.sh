#!/bin/bash

########################
# include the magic
########################

TOP=$(cd $(dirname $0) && pwd)

. $TOP/../demo-magic.sh
. $TOP/../util.sh

sudo sleep 1
# hide the evidence
clear

comment "First, create a new network namespace"
pe "sudo ip netns add ns1"

comment "Display the network interfaces in the root namespace"
pe "ip a"

comment "Run a shell in the new namespace"
pe_as "sudo ip netns exec ns1 bash" "sudo ip netns exec ns1 bash _demo.sh"

info "End of the demo"
