ip netns add red
ip netns add blue
echo "created namespaces red and blue"
ip netns 
ip link add veth-red type veth peer name veth-blue
ip link set veth-red netns red
ip link set veth-blue netns blue
ip netns exec red ip addr add 192.168.15.1/24 dev veth-red
ip netns exec blue ip addr add 192.168.15.2/24 dev veth-blue
ip netns exec red ip link set veth-red up
ip netns exec blue ip link set veth-blue up
echo "created veth pairs and assigned IPs"
ip netns exec red ping -c 3 192.168.15.2
ip netns exec blue ping -c 3 192.168.15.1
ip netns exec red arp
ip netns exec blue arp