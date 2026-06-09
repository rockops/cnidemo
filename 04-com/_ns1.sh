#!/bin/bash

########################
# include the magic
########################
TOP=$(cd $(dirname $0) && pwd)

. $TOP/../demo-magic.sh
. $TOP/../util.sh

DEMO_PROMPT="ns1# "

sudo sleep 1
# hide the evidence
clear

info "I am in the network namespace: ns1"

comment "Listening on 10.0.0.2, port 8080"
pe "socat TCP-LISTEN:8080,bind=10.0.0.2,fork -"
