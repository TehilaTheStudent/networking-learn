pause() {
  read -p "Press Enter to continue..."
}

IN_RED="ip netns exec red"
IN_BLUE="ip netns exec blue"

MY_LOG_SIGN="=========>"

echo "$MY_LOG_SIGN list all network namespaces you have"
ip netns
pause

echo "$MY_LOG_SIGN create red an blue network namespaces"
ip netns add red
ip netns add blue
pause

echo "$MY_LOG_SIGN list all network namespaces you have now"
ip netns
pause

echo "$MY_LOG_SIGN list interfaces on the host"
ip addr show
pause

echo "$MY_LOG_SIGN list interfaces in red"
$IN_RED ip addr show
pause

echo "$MY_LOG_SIGN list interfaces in blue"
$IN_BLUE ip addr show
pause

echo "$MY_LOG_SIGN arp in red"
$IN_RED arp
pause

echo "$MY_LOG_SIGN arp in blue"
$IN_BLUE arp
pause

echo "$MY_LOG_SIGN route in red"
$IN_RED route
pause

echo "$MY_LOG_SIGN route in blue"
$IN_BLUE route
pause

echo "$MY_LOG_SIGN we are gonna connect the 2 namespaces"
ip link add veth-red type veth peer name veth-blue
pause

echo "$MY_LOG_SIGN interfaces on the host now"
ip addr show
pause

echo "$MY_LOG_SIGN we gonna attach the virual cable to the namespaces"
ip link set veth-red netns red
ip link set veth-blue netns blue
pause

echo "$MY_LOG_SIGN see interfaces in red now"
$IN_RED ip addr show
pause

echo "$MY_LOG_SIGN see interfaces in blue now"
$IN_BLUE ip addr show
pause

echo "$MY_LOG_SIGN see interfaces on the host now"
ip addr show
pause

echo "$MY_LOG_SIGN route in red now"
$IN_RED route
pause

echo "$MY_LOG_SIGN route in blue now"
$IN_BLUE route
pause


echo "$MY_LOG_SIGN assign ip address to the interfaces we created inside the namespaces"
$IN_RED ip addr add 192.168.15.1/24 dev veth-red
$IN_BLUE ip addr add 192.168.15.2/24 dev veth-blue
pause

echo "$MY_LOG_SIGN see interfaces in red now"
$IN_RED ip addr show
pause

echo "$MY_LOG_SIGN see interfaces in blue now"
$IN_BLUE ip addr show
pause

echo "$MY_LOG_SIGN bring up the interfaces we created inside the namespaces"
$IN_RED ip link set veth-red up
$IN_BLUE ip link set veth-blue up
pause

echo "$MY_LOG_SIGN see interfaces in red now"
$IN_RED ip addr show
pause

echo "$MY_LOG_SIGN see interfaces in blue now"
$IN_BLUE ip addr show
pause

echo "$MY_LOG_SIGN try ping blue->red!"
$IN_BLUE ping -c 3 192.168.15.1
pause

echo "$MY_LOG_SIGN arp in blue now"
$IN_BLUE arp
pause

echo "$MY_LOG_SIGN arp in red now"
$IN_RED arp
pause

echo "$MY_LOG_SIGN try ping red->blue!"
$IN_RED ping -c 3 192.168.15.2
pause




echo "$MY_LOG_SIGN clean up!"
ip netns del red
ip netns del blue
ip link del veth-red
pause

echo "$MY_LOG_SIGN check interfaces on the host now"
ip addr show
pause

echo "$MY_LOG_SIGN check network namespaces now"
ip netns
pause





