#!/bin/bash

########################
# include the magic
########################
. /home/ben/share_CNI/demo-magic.sh
. /home/ben/share_CNI/util.sh

TOP=$(cd $(dirname "$0")/.. && pwd -P)

sudo sleep 1

# hide the evidence
clear

info "Connect to the second node"
pe_as "ssh root@node2" "docker exec -it node2 bash /demo/06-multi/_node2.sh"

info "Finished !"
