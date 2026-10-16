## Connect to node1 and setup namespace

Setup the first node

```
cd /assets/scenarios/06-multi
./06-node1.sh
``` {{exec target=node hidden=true text="Create node1"}}


## Connect to node2 and setup namespace

Setup the node 2
```
cd /assets/scenarios/06-multi
./06-node2.sh
``` {{exec target=ns hidden=true text="Create node2"}}

![Schema](step6-1.png)

## Setup the connection from node1 to node2

Connect bridges on node 1 and node 2 together

![Schema](step6-2.png)

## Create a tunnel between the two bridges

Physically, connection is made by 2 UDP connections<br />
Check connectivity between node2 and node1

```
go
``` {{exec target=node hidden=true text="Start"}}

![Schema](step6-3.png)

## Check connectivity

Check connectivity between node1 and node2

```
go
``` {{exec target=ns hidden=true text="Start"}}


