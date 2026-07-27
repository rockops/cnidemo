# Network Namespaces (netns) Demo

This directory demonstrates how to create and inspect isolated Linux network namespaces.

## Target of the Demo

Demonstrate the creation of a standalone, isolated network namespace (`ns1`) and observe how its network stack (including loopback and network interfaces) is completely separated from the host's root network namespace.

## Kernel Mechanisms Demoed

*   **Network Namespaces (`netns`)**: Creating isolated network environments within the Linux kernel to segment routing, IP tables, and interfaces.
*   **Isolated Interface States**: Observing the default unconfigured loopback (`lo`) state and lack of default physical/virtual interfaces in newly created namespaces.

## How to Execute the Demo

1.  Run the interactive setup script:
    ```bash
    ./demo.sh
    ```
2.  Press `Enter` to step through the command execution:
    *   Create the network namespace: `sudo ip netns add ns1`
    *   Display root namespace interfaces: `ip a`
    *   Enter the namespace and run the child script `_demo.sh` to display the isolated interfaces inside `ns1`.
