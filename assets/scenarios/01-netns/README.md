# Network Namespaces (netns) Demo

This directory demonstrates how to create, inspect, and test communication in an isolated Linux network namespace (`ns1`).

## Target of the Demo

1. Demonstrate the creation of a standalone, isolated network namespace (`ns1`).
2. Observe how its network stack (including loopback and network interfaces) is completely separated from the host's root network namespace.
3. Show that the loopback (`lo`) interface is `DOWN` by default in a new namespace and bring it `UP`.
4. Run a simple echo server on `localhost` (`127.0.0.1:8080`) inside `ns1`.
5. Prove that `localhost` in `ns1` is completely distinct from the host's `localhost`:
   * Accessible from within `ns1` using `localhost` (returns echo content).
   * Not accessible on `localhost` from the main host (`Connection refused`).

## Kernel Mechanisms Demoed

* **Network Namespaces (`netns`)**: Creating isolated network environments within the Linux kernel to segment routing, IP tables, sockets, and interfaces.
* **Isolated Interface States**: Observing the default unconfigured loopback (`lo`) state (`DOWN`) and lack of physical/virtual interfaces in newly created namespaces.
* **Localhost & Loopback Isolation**: Sockets bound to `127.0.0.1` / `localhost` inside a network namespace are only reachable within that namespace's network stack and cannot be accessed from the host's loopback interface.

## How to Execute the Demo

1. Run the interactive setup script:
   ```bash
   ./demo.sh
   ```
2. Press `Enter` to step through each command:
   * Create the network namespace: `sudo ip netns add ns1`
   * Display node interfaces: `ip a` and `ip -br a show dev lo`
   * Enter the namespace and run `_demo.sh`:
     * Inspect interfaces inside `ns1` (observe `lo` state is `DOWN`)
     * Bring loopback up: `ip link set lo up`
     * Start the echo server on `127.0.0.1:8080`: `python3 echo_server.py 8080 &`
     * Verify local communication inside `ns1`: `curl -s http://localhost:8080/Hello-from-ns1`
     * Send custom POST payload: `curl -s -d 'Testing echo inside ns1' http://localhost:8080`
     * Exit the namespace back to the main host
   * Attempt to reach `localhost:8080` from the main host:
     * `curl -m 2 http://localhost:8080/Hello-from-host` -> `Connection refused`
   * Clean up the echo server.
