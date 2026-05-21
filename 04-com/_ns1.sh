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

comment "Listening on 10.0.0.2, port 8080"
pe "socat TCP-LISTEN:8080,bind=10.0.0.2,fork -"
