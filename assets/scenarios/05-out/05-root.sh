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

redirect "Ping the Internet from the ns1 namespace"
cont

comment "Configure NAT"
pe "sudo iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE"

sudo iptables -A FORWARD -i br0 -j ACCEPT
sudo iptables -A FORWARD -o br0 -j ACCEPT

redirect "Now you can ping the Internet from the ns1 namespace"
