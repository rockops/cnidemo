#!/bin/bash

########################
# include the magic
########################
TOP=$(cd $(dirname $0) && pwd)

. $TOP/../demo-magic.sh
. $TOP/../util.sh

sudo sleep 1
# hide the evidence
clear

DEMO_PROMPT=$PROMPT_NODE

cd demystifying-cni

kind delete clusters demystifying-cni

comment "Now, see it in action: Create a kind cluster"
pe "make cluster"

echo -n "Waiting for cluster to be ready"
until kubectl get sa default &>/dev/null; do
  echo -n "."
  sleep 2
done
echo " Ready!"

cd ..

comment "Try to run a pod without any CNI configured"
pe "kubectl run alpine --image=alpine -- sleep 10000"

info "Watch the pod status in another terminal"
cont

comment "Verify the status of the pod"
pe "kubectl get pod alpine"

error "It is stuck in the Pending state, We need to configure the CNI" "The node is not ready because there is no CNI configured"

pe "kubectl describe node | grep ready"

comment "Install the CNI plugin and its configuration file in the control plane"

pe_as "scp 10-demystifying.conf root@cp:/etc/cni/net.d/10-demystifying.conf" "docker cp 10-demystifying.conf demystifying-cni-control-plane:/etc/cni/net.d/10-demystifying.conf"
pe_as "scp demystifying root@cp:/opt/cni/bin/" "docker cp demystifying demystifying-cni-control-plane:/opt/cni/bin/demystifying"

docker exec -it demystifying-cni-control-plane chmod +x /opt/cni/bin/demystifying

info "Connect to the cluster control plan and verify the CNI is present"
pe_as "ssh root@cp" "sleep 1"

DEMO_PROMPT=$PROMPT_CP

info "Verify that the CNI plugin is present"
pe_as "ls -l /opt/cni/bin/demystifying" "docker exec demystifying-cni-control-plane ls -l /opt/cni/bin/demystifying"
pe_as "ls -l /etc/cni/net.d/10-demystifying.conf" "docker exec demystifying-cni-control-plane ls -l /etc/cni/net.d/10-demystifying.conf"

info "Verify that the CNI has been invoked"
pe_as "cat /tmp/demystifying.log" "docker exec demystifying-cni-control-plane sh -c 'until [ -f /tmp/demystifying.log ]; do sleep 1; done && cat /tmp/demystifying.log'"

info "Go back to the host"
pe_as "exit" "sleep 1"

DEMO_PROMPT=$PROMPT_NODE

info "It works !" "Enter in the pod to show its IP address"
pe "kubectl exec -it alpine -- ip a"

info "It has been assigned the IP address 10.244.0.20 by the CNI plugin !"
