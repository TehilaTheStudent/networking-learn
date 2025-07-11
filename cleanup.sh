#!/bin/bash
set -e

echo "🧹 Cleaning up namespaces, interfaces, and bridge..."

# Delete namespaces
ip netns del red 2>/dev/null || echo "Namespace 'red' already removed"
ip netns del blue 2>/dev/null || echo "Namespace 'blue' already removed"

# Delete bridge and interfaces
ip link del v-net-0 2>/dev/null || echo "Bridge 'v-net-0' already deleted"
ip link del veth-red-br 2>/dev/null || true
ip link del veth-blue-br 2>/dev/null || true
ip link del veth-red 2>/dev/null || true
ip link del veth-blue 2>/dev/null || true

# Optional: Reset bridge netfilter settings
# sysctl -w net.bridge.bridge-nf-call-iptables=1 >/dev/null 2>&1 || true
# sysctl -w net.bridge.bridge-nf-call-ip6tables=1 >/dev/null 2>&1 || true
# sysctl -w net.bridge.bridge-nf-call-arptables=1 >/dev/null 2>&1 || true

echo "✅ Cleanup complete."
