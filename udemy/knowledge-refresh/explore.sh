pause() {
  read -p "Press Enter to continue..."
}

echo "lets explore the networking in the host"
pause

echo "ip link:"
ip link
pause

echo "ip addr:"
ip addr
pause

echo "ip route:"
ip route
pause

echo "cat this host forward packets from one interface to another? checking /proc/sys/net/ipv4/ip_forward:"
cat /proc/sys/net/ipv4/ip_forward
pause

echo "cat /etc/networks:"
cat /etc/networks
pause

echo "cat /etc/resolv.conf:"
cat /etc/resolv.conf
pause

echo "cat /etc/hosts:"
cat /etc/hosts
pause

echo "cat /etc/nsswitch.conf:"
cat /etc/nsswitch.conf
pause

