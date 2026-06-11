#!/usr/bin/env bash
set -e

echo "=== Installing APT dependencies ==="
sudo apt-get update
sudo apt-get install -y \
  iproute2 \
  iputils-ping \
  bridge-utils \
  net-tools \
  tcpdump \
  socat \
  telnet \
  jq \
  bat \
  pv \
  make

# Ensure batcat is globally accessible
if command -v batcat &> /dev/null; then
  sudo ln -sf "$(which batcat)" /usr/local/bin/batcat
fi

echo "=== Installing kind ==="
KIND_VERSION="v0.23.0"
curl -Lo ./kind "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64"
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

echo "=== Installing kubectl ==="
KUBECTL_STABLE_VER=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_STABLE_VER}/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

echo "=== Environment Setup Complete ==="
