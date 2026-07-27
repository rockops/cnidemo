#!/usr/bin/env bash

mkdir -p /rockdemo
cd /rockdemo

ls pv*.deb 2>/dev/null || {
    apt-get download pv || {
        apt-get update
        apt-get download pv
    }
}

ls libwrap0*.deb 2>/dev/null || {
    apt-get download libwrap0 || {
        apt-get update
        apt-get download libwrap0
    }
}

ls socat*.deb 2>/dev/null || {
    apt-get download socat || {
        apt-get update
        apt-get download socat
    }
}

dpkg -i pv*.deb
dpkg -i libwrap0*.deb
dpkg -i socat*.deb

echo "=== Installing kind ==="
KIND_VERSION="v0.23.0"
test -f ./kind || curl -Lo ./kind "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64"
chmod +x ./kind
sudo cp ./kind /usr/local/bin/kind

echo "=== Installing kubectl ==="
KUBECTL_STABLE_VER=$(curl -L -s https://dl.k8s.io/release/stable.txt)
test -f ./kubectl || curl -LO "https://dl.k8s.io/release/${KUBECTL_STABLE_VER}/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo cp ./kubectl /usr/local/bin/kubectl

echo "=== Environment Setup Complete ==="
