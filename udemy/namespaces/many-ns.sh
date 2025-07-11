# create ns
ip netns add red
ip netns add blue
# add interface and set it up
ip link add v-net-0 type bridge
ip link set dev v-net-0 up
# create cables
ip link add veth-red type veth peer name veth-red-br
ip link add veth-blue type veth peer name veth-blue-br
# connect the cables to both ends
ip link set veth-red netns red
ip link set veth-blue netns blue 
ip link set veth-red-br master v-net-0
ip link set veth-blue-br master v-net-0
# assign IPs
ip netns exec red ip addr add 192.168.15.1/24 dev veth-red
ip netns exec blue ip addr add 192.168.15.2/24 dev veth-blue
# set interfaces up
ip netns exec red ip link set veth-red up
ip netns exec blue ip link set veth-blue up
# bring up bridge ends
ip link set veth-red-br up
ip link set veth-blue-br up
# need also to allow this
# sysctl -w net.bridge.bridge-nf-call-iptables=0
# sysctl -w net.bridge.bridge-nf-call-ip6tables=0
# sysctl -w net.bridge.bridge-nf-call-arptables=
# ping test
ip netns exec red ping -c 3 192.168.15.2
ip netns exec blue ping -c 3 192.168.15.1

# connect with host
# now i cant reach my host:  sudo ip netns exec red ping 10.9.8.5: ping: connect: Networak is unreachable
ip addr add 192.168.15.5/24 dev v-net-0
# now we can ping red and blue from host
ping -c 3 192.168.15.1 
ping -c 3 192.168.15.2
# ping host from red and blue
ip netns exec red ping -c 3 192.168.15.5
ip netns exec blue ping -c 3 192.168.15.5

# now i want to reach something that is reachable from host, but not from red or blue  sudo ip netns exec red ping 10.9.8.8 ping: connect: Network is unreachable
# i need to add a route to the host
ip netns exec red ip route add 10.9.8.0/28 via 192.168.15.5
ip netns exec blue ip route add 10.9.8.0/28 via 192.168.15.5
# check route tables
ip netns exec red ip route
ip netns exec blue ip route
# if we ping now, we wont get a response,  sudo ip netns exec red ping 10.9.8.8
# we need nat
iptables -t nat -A POSTROUTING -s 192.168.15.0/24 -j MASQUERADE