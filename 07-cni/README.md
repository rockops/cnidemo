# Demystifying CNI (Container Network Interface) Demo

This directory demonstrates how a custom Container Network Interface (CNI) plugin is implemented and how it is consumed by Kubernetes to set up pod networking.

## Target of the Demo

Build and deploy a simple, bash-based CNI plugin (`demystifying`) to a local `kind` Kubernetes cluster. The demo shows how Kubelet is blocked from running pods without a CNI plugin, and how it automatically schedules and runs pods once the configuration and plugin binary are installed.

## CNI & Kernel Mechanisms Demoed

*   **CNI Specification Protocol**: Handling standard actions (`ADD`, `DEL`, `VERSION`) and environment variables (`CNI_COMMAND`, `CNI_NETNS`, `CNI_IFNAME`, `CNI_CONTAINERID`) defined by the CNCF CNI specification.
*   **Kubernetes CRI-to-CNI Integration**: Placing CNI configuration files in `/etc/cni/net.d/` and plugin binaries in `/opt/cni/bin/` to register the network provider with the container runtime.
*   **Dynamic Network Namespace Hooking**: Automating the process of creating a `veth` pair, linking it into the target container's namespace (`CNI_NETNS`), assigning IPs, adding static route tables, and renaming the container interface to `eth0` (`CNI_IFNAME`) on container startup.

## How to Execute the Demo

Ensure you have `docker`, `kind`, and `kubectl` installed on the host:

1.  Execute the main demo driver script:
    ```bash
    ./07-demo.sh
    ```
2.  Follow the interactive steps to:
    *   Inspect the CNI plugin source code and config.
    *   Watch a Kubernetes pod get stuck in a `Pending` state due to `NetworkReady=false`.
    *   Deploy the plugin binary and configuration to the control-plane node.
    *   Verify that the pod is successfully assigned an IP (`10.244.0.20`) and transitioned to the `Running` state.
