#!/bin/bash

########################
# include the magic
########################
. /home/ben/share_CNI/demo-magic.sh
. /home/ben/share_CNI/util.sh

sudo sleep 1
# hide the evidence
clear

info "I am in the root namespace"

comment "Create the veth pair"
pe "sudo ip link add veth-host type veth peer name veth-ns"

comment "Add one end of the veth pair to the namespace"
pe "sudo ip link set veth-ns netns ns1"

comment "Assign an IP to the host side of the veth pair"
pe "sudo ip addr add 10.0.0.1/24 dev veth-host"

comment "Bring the interface up"
pe "sudo ip link set veth-host up"

comment "Display the network interfaces in the root namespace"
pe "ip a"

redirect "Do the same steps in the network namespace"

cont

redirect "Ping the namespace from the host"
pe "ping -c 3 10.0.0.2"

