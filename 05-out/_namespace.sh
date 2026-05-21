#!/bin/bash

########################
# include the magic
########################
. /home/ben/share_CNI/demo-magic.sh
. /home/ben/share_CNI/util.sh

DEMO_PROMPT="ns1# "

sudo sleep 1
# hide the evidence
clear

info "I am in the network namespace: ns1"

comment "Try to ping an external host"
pe "ping -c 1 8.8.8.8"

error "It fails !" "We need to configure the default route"

pe 'sudo ip route add default via 10.0.0.254'

comment "Try to ping an external host"
pe "ping -c 1 8.8.8.8"

error "Still failing !" "We need to configure the NAT in the root namespace"
cont

comment "Try to ping an external host"
pe "ping -c 3 8.8.8.8"

info "It works !"
