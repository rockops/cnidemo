# Multi-Namespace Bridge Demo

This directory demonstrates how to connect multiple isolated network namespaces (`ns1` and `ns2`) using a virtual Linux bridge.

## Target of the Demo

Establish connectivity between two independent namespaces (`ns1` at `10.0.0.1` and `ns2` at `10.0.0.2`) by binding their host-side `veth` interfaces to a common software bridge (`br0`) acting as a Layer 2 switch.

## Kernel Mechanisms Demoed

*   **Linux Software Bridge (`br0`)**: A virtual switch that aggregates multiple network interfaces and forwards Ethernet frames between them.
*   **Network Namespaces (`netns`)**: Running multiple isolated network stacks (`ns1`, `ns2`).
*   **Virtual Ethernet (`veth`) Pairs**: Creating separate veth pairs for each namespace and binding the host side to the bridge using `ip link set <dev> master br0`.
*   **IP Configuration**: Removing individual IPs from host-side veth interfaces and assigning a single subnet IP (`10.0.0.254/24`) to the bridge itself.

## How to Execute the Demo

This demo requires coordination between the host and namespace contexts:

1.  **Terminal 1 (Host)**: Run the host-side setup script:
    ```bash
    ./03-root.sh
    ```
2.  **Terminal 2 (Namespace)**: When prompted, run the namespace-side setup script:
    ```bash
    ./03-namespace.sh
    ```
    This script will configure `ns2`, attempt to ping `ns1` (which will fail initially), and wait for the bridge to be created on the host before verifying successful pings.
3.  **Terminal 1 (Host)**: Complete the host script to confirm bridge connectivity.
