#!/bin/bash

########################
# include the magic
########################
TOP=$(cd $(dirname $0) && pwd)

. $TOP/../demo-magic.sh
. $TOP/../util.sh

TOP=$(cd $(dirname "$0")/.. && pwd -P)

sudo sleep 1

docker  build . -t demo

docker run -dit --name node1 --hostname node1 --privileged -v $TOP:/demo demo
docker run -dit --name node2 --hostname node2 --privileged -v $TOP:/demo demo

# hide the evidence
clear

info "Connect to the first node"
pe_as "ssh root@node1" "docker exec -it node1 bash /demo/06-multi/_node1.sh"

info "Finished !"
