#!/bin/bash

########################
# include the magic
########################
TOP=$(cd $(dirname $0) && pwd)

. $TOP/../demo-magic.sh
. $TOP/../util.sh

DEMO_PROMPT=$PROMPT_NS2

sudo sleep 1
# hide the evidence
clear

info "I am in the network namespace: ns2"

comment "Connecting to 10.0.0.1, port 8080" "Enter a messages to send to the server. Type 'exit' to quit."

while true; do
  echo -n "> "
  read MSG
  if [[ "$MSG" == "exit" ]]; then
    break
  fi
  echo "$(date): $MSG" > /dev/tcp/10.0.0.1/8080
done

