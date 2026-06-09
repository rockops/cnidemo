#!/bin/bash

########################
# include the magic
########################
TOP=$(cd $(dirname $0) && pwd)

. $TOP/../demo-magic.sh
. $TOP/../util.sh

DEMO_PROMPT="ns2# "

sudo sleep 1
# hide the evidence
clear

info "I am in the network namespace: ns2"

comment "Connecting to 10.0.0.2, port 8080 [CTRL+5 to close]"
pe "telnet 10.0.0.2 8080"

