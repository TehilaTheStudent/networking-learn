#!/bin/bash
set -e

# Clean up any old leftovers
ip netns del red 2>/dev/null || true
ip netns del blue 2>/dev/null || true
ip link del v-net-0 2>/dev/null || true
ip link del veth-red 2>/dev/null || true
ip link del veth-blue 2>/dev/null || true

# Create namespaces
ip netns add red
ip netns add blue

# Create bridge
ip link add name v-net-0 type bridge
ip link set v-net-0 up

# Create veth pairs
ip link add veth-red type veth peer name veth-red-br
ip link add veth-blue type veth peer name veth-blue-br

# Assign one end of each veth to the namespace
ip link set veth-red netns red
ip link set veth-blue netns blue

# Attach bridge ends to the bridge
ip link set veth-red-br master v-net-0
ip link set veth-blue-br master v-net-0

# Bring up bridge ends
ip link set veth-red-br up
ip link set veth-blue-br up

# Bring up bridge itself (again just in case)
ip link set v-net-0 up

# Set up namespace interfaces and IPs
ip netns exec red ip addr add 192.168.15.1/24 dev veth-red
ip netns exec blue ip addr add 192.168.15.2/24 dev veth-blue

ip netns exec red ip link set veth-red up
ip netns exec blue ip link set veth-blue up

# Bring up loopback in both namespaces
# ip netns exec red ip link set lo up
# ip netns exec blue ip link set lo up

# Optional: Disable bridge netfilter (if enabled, can block traffic)
# modprobe br_netfilter || true
# sysctl -w net.bridge.bridge-nf-call-iptables=0
# sysctl -w net.bridge.bridge-nf-call-ip6tables=0
# sysctl -w net.bridge.bridge-nf-call-arptables=0

echo "✅ Setup complete. Testing connectivity..."
echo "🔴 red → blue"
ip netns exec red ping -c 3 192.168.15.2

echo "🔵 blue → red"
ip netns exec blue ping -c 3 192.168.15.1
