# Namespace TCP Communication Demo

This directory demonstrates application-level TCP socket communication between two isolated namespaces (`ns1` and `ns2`) connected via the bridge.

## Target of the Demo

Establish a TCP connection between a listener program running inside `ns1` and a client program running inside `ns2`, proving that network isolation allows controlled inter-namespace traffic over a shared Layer 2 bridge.

## Kernel Mechanisms Demoed

*   **Socket Bind & Listen**: Sockets binding to specific namespace-bound IP addresses (`10.0.0.2` on port `8080` inside `ns1`).
*   **Inter-Namespace Layer 3 Routing**: TCP packet traversal from `ns2` through its veth interface, across the host bridge (`br0`), and down into `ns1` via `ns1`'s veth interface.

## How to Execute the Demo

Run this demo using two terminal windows to view the interactive communication:

1.  **Terminal 1 (Listener in `ns1`)**: Start the TCP server listener inside `ns1`:
    ```bash
    ./04-ns1.sh
    ```
2.  **Terminal 2 (Client in `ns2`)**: Connect to the listener from `ns2`:
    ```bash
    ./04-ns2.sh
    ```
    Once connected, you can type messages in Terminal 2 and see them print in Terminal 1. Use `Ctrl+5` or `Ctrl+D` to close the connection.
