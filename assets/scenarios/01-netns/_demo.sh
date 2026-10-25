#!/usr/bin/env bash

TOP=$(cd $(dirname $0) && pwd)

. $TOP/../demo-magic.sh
. $TOP/../util.sh

DEMO_PROMPT=$PROMPT_NS1

info "I am in the network namespace: ns1"

ip link set lo up

comment "Display the network interfaces in the current namespace"
pe "ip a"

comment "Start an echo server on localhost (127.0.0.1:8080)" \
        "in the background"
pe "python3 echo_server.py 8080 &"
sleep 1

comment "Check that the 8080 port is listening"
pe "ss -anp | grep 8080"

comment "Test local communication inside ns1 using localhost"
pe "curl -s http://localhost:8080/Hello-from-ns1"

info "Local communication on localhost inside ns1 is working!"

comment "Now exit the namespace back to the main host"
pe_as "exit" "exit"
