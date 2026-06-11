# cnidemo

Learn how container networking and Kubernetes CNI plugins work under the hood by building container network setups from scratch using Linux kernel primitives.

Each folder contains an interactive demo driven by `demo-magic.sh`.

---

## Step-by-Step Learning Path

### [01. Network Namespaces](file:///home/ben/src/cnidemo/01-netns) (`01-netns`)
*   **Target**: Create and inspect isolated environments.
*   **Mechanisms**: Linux Network Namespaces (`netns`).
*   **Goal**: Observe how a namespace segments network devices, routing tables, and firewall rules, leaving loopback (`lo`) and interfaces completely isolated from the host.

### [02. Virtual Ethernet Pairs](file:///home/ben/src/cnidemo/02-veth) (`02-veth`)
*   **Target**: Establish host-to-namespace connectivity.
*   **Mechanisms**: Virtual Ethernet (`veth`) pairs, IP addressing, and link state activation.
*   **Goal**: Create a virtual point-to-point network tunnel to ping between the root host namespace and the isolated namespace.

### [03. Multi-Namespace Bridge](file:///home/ben/src/cnidemo/03-multi) (`03-multi`)
*   **Target**: Interconnect multiple namespaces on the same host.
*   **Mechanisms**: Linux Software Bridge (`br0`), multi-namespace routing, and device master attachment.
*   **Goal**: Move from single-link connections to a virtual Layer 2 switch structure, allowing namespaces to communicate through a shared bridge gateway.

### [04. TCP Socket Communication](file:///home/ben/src/cnidemo/04-com) (`04-com`)
*   **Target**: Stream application-level traffic across namespaces.
*   **Mechanisms**: Socket binding and TCP Layer 3 transit.
*   **Goal**: Start a listening socket inside one namespace and connect to it from another using standard tools (`socat`, `telnet`) over the virtual bridge.

### [05. Egress & External Routing](file:///home/ben/src/cnidemo/05-out) (`05-out`)
*   **Target**: Grant namespaces external internet access.
*   **Mechanisms**: Default routing tables (`ip route`), kernel IP forwarding, and IPTables Source NAT (masquerading).
*   **Goal**: Route private subnet traffic from namespaces through the host's physical network adapter out to the Internet (e.g. pinging `8.8.8.8`).

### [06. Multi-Host VXLAN Overlay](file:///home/ben/src/cnidemo/06-multi) (`06-multi`)
*   **Target**: Enable networking across multiple virtual hosts (nodes).
*   **Mechanisms**: Virtual eXtensible LAN (VXLAN) tunnels, bridge-to-tunnel aggregation, and privileged container networking.
*   **Goal**: Connect namespaces located on separate simulated nodes (Docker containers) using a VXLAN overlay tunnel over UDP port 4789.

### [07. Custom CNI Plugin](file:///home/ben/src/cnidemo/07-cni) (`07-cni`)
*   **Target**: Implement a functional Kubernetes CNI plugin.
*   **Mechanisms**: CNI Specification Protocol (`ADD`/`DEL`/`VERSION`), CRI-to-CNI filesystem registration, and dynamic namespace setup.
*   **Goal**: Create a bash-written CNI plugin, deploy it inside a `kind` cluster, and observe Kubelet automatically calling it to transition pending Pods to the running state.

---

## Global Cleanup

To tear down all interfaces, bridges, namespaces, test containers, and local clusters created during these demos, run the global cleanup script from the root directory:

```bash
sudo ./cleanup.sh
```
