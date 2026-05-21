#!/usr/bin/env bash

sudo ip link delete veth-host
sudo ip link delete veth-host2
sudo ip netns delete ns1
sudo ip netns delete ns2
sudo ip link delete br0
sudo iptables -t nat -D POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE
sudo iptables -D FORWARD -i br0 -j ACCEPT
sudo iptables -D FORWARD -o br0 -j ACCEPT

cd ~/share_CNI/07-cni/demystifying-cni
make destroy

docker rm node1 -f
docker rm node2 -f

kind delete clusters --all
docker network prune -f
docker container prune -f
