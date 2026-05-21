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

comment "Create a new network namespace"
pe "sudo ip netns add ns2"

comment "Create a second veth pair"
pe "sudo ip link add veth-host2 type veth peer name veth-ns2"
pei "sudo ip addr add 10.0.0.4/24 dev veth-host2"
pei "sudo ip link set veth-host2 up"

comment "Attach veth-ns2 to the second namespace"
pe "sudo ip link set veth-ns2 netns ns2"

redirect "Do the same steps in the second namespace"
cont

comment "Create the bridge"
pe "sudo ip link add br0 type bridge"
pei "sudo ip addr add 10.0.0.254/24 dev br0"
pei "sudo ip link set br0 up"

comment "The bridge is now created and its IP is 10.0.0.254" "Before attaching the 2 host_veth to the bridge, we need to unassign their IP" "In a real CNI plugin, the veth_host are creatred without an IP"
pe "sudo ip addr del 10.0.0.1/24 dev veth-host"
pei "sudo ip addr del 10.0.0.4/24 dev veth-host2"

comment "Now, we can attach the 2 interfaces to the bridge"
pe "sudo ip link set veth-host master br0"
pei "sudo ip link set veth-host2 master br0"

comment "Display the bridge interfaces"
pe "ip a"

redirect "Enter the second namespace to check the connectivity"
cont

comment "You can ping both namespaces from the host"
pe "ping -c 2 10.0.0.2"
pei "ping -c 2 10.0.0.3"
