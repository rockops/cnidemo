#!/bin/bash

########################
# include the magic
########################
. /home/ben/share_CNI/demo-magic.sh
. /home/ben/share_CNI/util.sh

DEMO_PROMPT="ns2# "

sudo sleep 1
# hide the evidence
clear

info "I am in the network namespace: ns2"

comment "Connecting to 10.0.0.2, port 8080 [CTRL+5 to close]"
pe "telnet 10.0.0.2 8080"

