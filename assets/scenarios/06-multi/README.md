# Multi-Host Networking with VXLAN Demo

This directory demonstrates how to establish connectivity between pods (namespaces) running on different physical or virtual hosts (simulated by Docker containers) using a VXLAN (Virtual eXtensible LAN) overlay tunnel.

## Target of the Demo

Connect `pod1` on `node1` (`10.1.1.1`) to `pod2` on `node2` (`10.1.2.2`) across a simulated multi-host boundary. This mimics the multi-host network routing topology used by popular Kubernetes CNI plugins like Flannel.

## Kernel Mechanisms Demoed

*   **VXLAN Overlay with Multicast (`group 239.1.1.1`)**: An overlay network technology that encapsulates Layer 2 Ethernet frames inside Layer 4 UDP packets (destination port `4789`). Using a multicast group enables any number of nodes (2, 3, or more) to participate in the same overlay network without point-to-point mesh tunnels or switching loops.
*   **Dynamic MAC Learning**: The Linux kernel learns remote pod MAC addresses to host IP mappings over the multicast group, sending subsequent unicast traffic directly.
*   **Bridge-to-Tunnel Bridging**: Attaching the VXLAN interface (`vxlan0`) to the local bridge (`br0`) to bridge the physical/virtual network interface on the host with the namespace networks.
*   **Privileged Docker Containers**: Running containers with `--privileged` flags to act as standalone nodes capable of creating network namespaces, bridges, and VXLAN interfaces.

## How to Execute the Demo

This demo uses Docker containers (`node1`, `node2`, and `node3`) to represent different nodes:

1.  **Terminal 1 (Host)**: Start the demo infrastructure and run the `node1` setup script:
    ```bash
    ./06-node1.sh
    ```
    This builds the Docker image, starts all nodes, and executes `_node1.sh` inside the `node1` container.
2.  **Terminal 2 (Host)**: Configure the second node by running:
    ```bash
    ./06-node2.sh
    ```
    This executes `_node2.sh` inside the `node2` container.
3.  Follow the interactive prompts in both terminals to create local namespaces, configure VXLAN multicast interfaces, and verify pod-to-pod cross-node communication via `ping`.
4.  **Terminal 2 (Host)**: Add a third node seamlessly into the overlay:
    ```bash
    ./06-node3.sh
    ```
    This configures `node3` with `pod3` (`10.1.3.3`) and joins `group 239.1.1.1`, verifying cross-node ping to both `pod1` and `pod2` without modifying `node1` or `node2`.
