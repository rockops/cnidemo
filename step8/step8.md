# Multi-node Networking: Layer 3 Routing (Annex)

In Step 6, multi-node connectivity was achieved at **Layer 2** using a VXLAN overlay tunnel.

This annex demonstrates an alternative, highly popular CNI approach: **pure Layer 3 routing** (used by CNIs like Calico in unencapsulated mode or AWS VPC CNI).

Instead of encapsulating packets into UDP tunnels:
- Each node is assigned a distinct pod CIDR subnet (`10.1.1.0/24` on node1, `10.1.2.0/24` on node2).
- The Linux host kernel acts as a router.
- Nodes exchange routes (`ip route add <pod-subnet> via <node-ip>`), allowing native IP packets to be forwarded with zero encapsulation overhead.

---

## Connect to node1 and setup namespace

Setup the first node with pod subnet `10.1.1.0/24`:

```
cd /assets/scenarios/08-routing
./08-node1.sh
``` {{exec target=node hidden=true text="Create node1"}}


## Connect to node2 and setup namespace

Setup the second node with pod subnet `10.1.2.0/24`:

```
cd /assets/scenarios/08-routing
./08-node2.sh
``` {{exec target=ns hidden=true text="Create node2"}}


## Layer 3 routing: Node2 to Node1

Node2 initially cannot reach `pod1` (`10.1.1.1`).  
To fix this, add a route directing traffic for `10.1.1.0/24` to node1 (`172.17.0.2`) via `eth0`.


## Setup return route on Node1

Now add the symmetric return route on node1 for `10.1.2.0/24` via node2 (`172.17.0.3`):

```
go
``` {{exec target=node hidden=true text="Start"}}


## Check connectivity

Test full two-way communication between `pod2` and `pod1`:

```
go
``` {{exec target=ns hidden=true text="Start"}}
