# External Routing & NAT (Egress) Demo

This directory demonstrates how to configure routing and network address translation (NAT) to allow an isolated network namespace (`ns1`) to reach external networks (e.g., the Internet).

## Target of the Demo

Enable egress internet connectivity (e.g., pinging `8.8.8.8`) from inside the isolated network namespace `ns1` by configuring default routing paths, enabling kernel IP forwarding, and setting up iptables masquerading on the host.

## Kernel Mechanisms Demoed

*   **Routing Tables & Default Routes (`ip route`)**: Defining the default gateway (`10.0.0.154` via `br0`) inside the namespace.
*   **IP Forwarding**: Directing the host kernel to act as a router and forward transit traffic between virtual bridge `br0` and the host's physical network interface.
*   **Source NAT / IP Masquerading (`iptables -t nat`)**: Rewriting the source IP of outgoing packets from the private subnet (`10.0.0.0/24`) to the host's external IP, enabling reply routing.
*   **IPTables Forwarding Rules (`FORWARD` chain)**: Permitting traffic to pass through the host between the bridge (`br0`) and the external network.

## How to Execute the Demo

This demo shows the transition from no routing, to local routing, to NAT-enabled routing:

1.  **Terminal 1 (Namespace)**: Run the namespace-side testing script:
    ```bash
    ./05-namespace.sh
    ```
    This script will try to ping `8.8.8.8` (fails), set up the default gateway, try again (fails without NAT), and wait.
2.  **Terminal 2 (Host)**: Run the host-side NAT configuration script:
    ```bash
    ./05-root.sh
    ```
    This will apply the `iptables` POSTROUTING masquerade and forwarding rules.
3.  **Terminal 1 (Namespace)**: Resume the script to witness a successful ping to `8.8.8.8`.
