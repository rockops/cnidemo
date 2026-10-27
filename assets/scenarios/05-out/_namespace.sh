#!/bin/bash

########################
# include the magic
########################
TOP=$(cd $(dirname $0) && pwd)

. $TOP/../demo-magic.sh
. $TOP/../util.sh

DEMO_PROMPT=$PROMPT_NS1

sudo sleep 1
# hide the evidence
clear

info "I am in the network namespace: ns1"

comment "Try to ping an external host"
pe "ping -c 1 8.8.8.8"
#pe "curl -sS -m 5 https://ifconfig.me"

error "It fails !" "We need to configure the default route"

pe 'sudo ip route add default via 10.0.0.254'

comment "Try to ping an external host"
pe "ping -c 1 8.8.8.8"
#pe "curl -sS -m 5 https://ifconfig.me"

error "Still failing !" "We need to configure the NAT in the node"
cont

comment "Try to ping an external host"
pe "ping -c 3 8.8.8.8"

comment "We can also test an HTTPS connection"
pe "curl -sS https://ifconfig.me"

info "It works !"
