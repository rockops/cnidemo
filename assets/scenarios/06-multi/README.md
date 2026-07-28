# Multi-Host Networking with VXLAN Demo

This directory demonstrates how to establish connectivity between pods (namespaces) running on different physical or virtual hosts (simulated by Docker containers) using a VXLAN (Virtual eXtensible LAN) overlay tunnel.

## Target of the Demo

Connect `pod1` on `node1` (`10.1.1.1`) to `pod2` on `node2` (`10.1.2.2`) across a simulated multi-host boundary. This mimics the multi-host network routing topology used by popular Kubernetes CNI plugins like Flannel.

## Kernel Mechanisms Demoed

*   **VXLAN (Virtual eXtensible LAN)**: An overlay network technology that encapsulates Layer 2 Ethernet frames inside Layer 4 UDP packets (destination port `4789`), allowing virtual subnets to span across physical host boundaries.
*   **Bridge-to-Tunnel Bridging**: Attaching the VXLAN interface (`vxlan0`) to the local bridge (`br0`) to bridge the physical/virtual network interface on the host with the namespace networks.
*   **Privileged Docker Containers**: Running containers with `--privileged` flags to act as standalone nodes capable of creating network namespaces, bridges, and VXLAN interfaces.

## How to Execute the Demo

This demo uses two Docker containers (`node1` and `node2`) to represent different nodes:

1.  **Terminal 1 (Host)**: Start the demo infrastructure and run the `node1` setup script:
    ```bash
    ./06-node1.sh
    ```
    This builds the Docker image, starts the nodes, and executes `_node1.sh` inside the `node1` container.
2.  **Terminal 2 (Host)**: Configure the second node by running:
    ```bash
    ./06-node2.sh
    ```
    This executes `_node2.sh` inside the `node2` container.
3.  Follow the interactive prompts in both terminals to create the local namespaces, configure the VXLAN interfaces, and verify pod-to-pod cross-node communication via `ping`.
