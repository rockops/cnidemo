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

DEMO_PROMPT=$PROMPT_NODE

info "I am in the root namespace"

comment "Create the veth pair"
pe "sudo ip link add veth-host type veth peer name veth-ns"

comment "We have 2 interfaces in the root namespace now"
pe "ip a show veth-ns && ip a show veth-host"

comment "Add one end of the veth pair to the namespace"
pe "sudo ip link set veth-ns netns ns1"

comment "One end of the veth pair is now in the namespace"
pe "ip a show veth-host"

comment "Assign an IP to the host side of the veth pair"
pe "sudo ip addr add 10.0.0.10/24 dev veth-host"

comment "Bring the interface up"
pe "sudo ip link set veth-host up"

comment "Display the network interfaces in the root namespace"
pe "ip a"

redirect "Do the same steps in the network namespace"

cont

redirect "Ping the namespace from the host"
pe "ping -c 3 10.0.0.1"

