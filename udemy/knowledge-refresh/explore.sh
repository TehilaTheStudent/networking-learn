pause() {
  read -p "Press Enter to continue..."
}

MY_LOG_SIGN="=========>"

echo "$MY_LOG_SIGN lets explore the networking in the host"
pause

echo "$MY_LOG_SIGN ip link:"
ip link
pause

echo "$MY_LOG_SIGN ip addr:"
ip addr
pause

echo "$MY_LOG_SIGN ip route:"
ip route
pause

echo "$MY_LOG_SIGN cat this host forward packets from one interface to another? checking /proc/sys/net/ipv4/ip_forward:"
cat /proc/sys/net/ipv4/ip_forward
pause

echo "$MY_LOG_SIGN cat /etc/networks:"
cat /etc/networks
pause

echo "$MY_LOG_SIGN cat /etc/resolv.conf:"
cat /etc/resolv.conf
pause

echo "$MY_LOG_SIGN cat /etc/hosts:"
cat /etc/hosts
pause

echo "$MY_LOG_SIGN cat /etc/nsswitch.conf:"
cat /etc/nsswitch.conf
pause

echo "$MY_LOG_SIGN traceroute to google.com:"
traceroute google.com
pause

echo "$MY_LOG_SIGN arp -an:"
arp -an
pause

echo "$MY_LOG_SIGN ip neigh:"
ip neigh
pause


# check
echo "$MY_LOG_SIGN check if firewall bridge traffic is enabled ( 1 = enabled, 0 = disabled)"
echo "$MY_LOG_SIGN cat /proc/sys/net/bridge/bridge-nf-call-iptables"
cat /proc/sys/net/bridge/bridge-nf-call-iptables
pause
echo "$MY_LOG_SIGN cat /proc/sys/net/bridge/bridge-nf-call-ip6tables"
cat /proc/sys/net/bridge/bridge-nf-call-ip6tables
pause
echo "$MY_LOG_SIGN cat /proc/sys/net/bridge/bridge-nf-call-arptables"
cat /proc/sys/net/bridge/bridge-nf-call-arptables
pause

# do thos only if this env var is set
if [ -n "$1" ]; then
REACHABLE_HOST_IP=$1
echo "ping $REACHABLE_HOST_IP"
ping -c 3 $REACHABLE_HOST_IP
pause

echo "see arp now:"
arp -an
pause

echo "see ip neigh now:"
ip neigh
pause
fi

