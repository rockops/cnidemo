#!/bin/bash

########################
# include the magic
########################
TOP=$(cd $(dirname $0) && pwd)

. $TOP/../demo-magic.sh
. $TOP/../util.sh

TOP=$(cd $(dirname "$0")/.. && pwd -P)

sudo sleep 1

# hide the evidence
clear

info "Connect to the third node"
docker exec -it node3 bash /demo/09-bgp/_node3.sh

info "Finished !"
