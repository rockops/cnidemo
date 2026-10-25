#!/bin/bash

########################
# include the magic
########################
TOP=$(cd $(dirname $0) && pwd)

. $TOP/../demo-magic.sh
. $TOP/../util.sh

TOP=$(cd $(dirname "$0")/.. && pwd -P)

sudo sleep 1

docker build . -t demo-bgp

docker rm -f $(docker ps -aq --filter "label=cni-demo-cleanup=true") 2>/dev/null || true

docker run -dit --name node1 --hostname node1 --privileged -v $TOP:/demo --label "cni-demo-cleanup=true" demo-bgp
docker run -dit --name node2 --hostname node2 --privileged -v $TOP:/demo --label "cni-demo-cleanup=true" demo-bgp
docker run -dit --name node3 --hostname node3 --privileged -v $TOP:/demo --label "cni-demo-cleanup=true" demo-bgp

# hide the evidence
clear

info "Connect to the first node"
docker exec -it node1 bash /demo/09-bgp/_node1.sh

info "Finished !"
