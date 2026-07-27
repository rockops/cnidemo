# Virtual Ethernet (veth) Demo

This directory demonstrates how to establish network connectivity between the host (root namespace) and an isolated network namespace using a Virtual Ethernet (`veth`) pair.

## Target of the Demo

Establish bi-directional network communication between the host and network namespace `ns1` by creating a virtual point-to-point connection, assigning IP addresses, and testing connectivity with `ping`.

## Kernel Mechanisms Demoed

*   **Network Namespaces (`netns`)**: Isolated network stacks (`ns1`).
*   **Virtual Ethernet (`veth`) Pairs**: Virtual wire interfaces (`veth-host` and `veth-ns`) where packets entering one interface emerge from the other.
*   **IP Routing & Addressing (`ip addr`)**: Assigning IPs (`10.0.0.1/24` on host, `10.0.0.1/24` in namespace) to interfaces on the same subnet.
*   **Interface Link Management (`ip link`)**: Activating loopback (`lo`) and veth interfaces.

## How to Execute the Demo

This demo requires two terminal sessions or contexts because it simulates operations in the root namespace and inside `ns1` concurrently:

1.  **Terminal 1 (Host)**: Run the host setup script:
    ```bash
    ./02-root.sh
    ```
2.  **Terminal 2 (Namespace)**: Once Terminal 1 pauses, run the namespace setup script:
    ```bash
    ./02-namespace.sh
    ```
3.  **Terminal 1 (Host)**: Type `go` and press `Enter` to resume and ping the namespace.
