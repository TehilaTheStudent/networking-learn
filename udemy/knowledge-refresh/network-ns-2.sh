pause() {
  read -p "Press Enter to continue..."
}

REACHABLE_FROM_HOST=$1
IN_RED="ip netns exec red"
IN_BLUE="ip netns exec blue"
HOST_IP=$(ip route get 1.1.1.1 | awk '{print $7}' | head -n1)
ip_cidr=$(ip -4 -o addr show scope global | awk '{print $4}' | head -n1)
HOST_NETWORK=$(ipcalc "$ip_cidr" | grep Network | awk '{print $2}')
MY_LOG_SIGN="=========>"
NS_NETWORK="192.168.15.0/24"
IPS=("192.168.15.1" "192.168.15.2" "192.168.15.3" "192.168.15.4")
V_NET_0_IP="192.168.15.5"
echo "$MY_LOG_SIGN list all network namespaces you have"
ip netns
pause

echo "$MY_LOG_SIGN create red, blue, green, yellow network namespaces"
ip netns add red
ip netns add blue
ip netns add green
ip netns add yellow
pause

echo "$MY_LOG_SIGN list all network namespaces you have now"
ip netns
pause

echo "$MY_LOG_SIGN list interfaces on the host"
ip addr show
pause

# explore interfaces in all namespaces
for ns in red blue green yellow; do
  echo "$MY_LOG_SIGN list interfaces in $ns"
  ip netns exec $ns ip addr show
  pause
done

# explore arp in all namespaces
for ns in red blue green yellow; do
  echo "$MY_LOG_SIGN arp in $ns"
  ip netns exec $ns arp
  pause
done

# explore route in all namespaces
for ns in red blue green yellow; do
echo "$MY_LOG_SIGN route in $ns"
ip netns exec $ns route
pause
done

# create linux bridge
echo "$MY_LOG_SIGN create linux bridge"
ip link add v-net-0 type bridge
pause

echo "$MY_LOG_SIGN see interfaces on the host now"
ip addr show
pause

# bring up the bridge
echo "$MY_LOG_SIGN bring up the bridge"
ip link set v-net-0 up
pause
echo "$MY_LOG_SIGN see interfaces on the host now"
ip addr show
pause

# create virtual cables
for ns in red blue green yellow; do
  echo "$MY_LOG_SIGN create virtual cable for $ns, called veth-$ns and veth-$ns-br"
  ip link add veth-$ns type veth peer name veth-$ns-br
  pause
done

# see interfaces on the host now
echo "$MY_LOG_SIGN see interfaces on the host now"
ip addr show
pause

# connect the cables to the bridge
for ns in red blue green yellow; do
  echo "$MY_LOG_SIGN connect the cable to the bridge for $ns,(specify master ) veth-$ns-br -> v-net-0"
  ip link set veth-$ns-br master v-net-0
  pause
done

echo "$MY_LOG_SIGN see interfaces on the host now"
ip addr show
pause

# connect the cables to the namespaces
for ns in red blue green yellow; do
  echo "$MY_LOG_SIGN connect the cable to the namespace for $ns,(specify netns) veth-$ns -> $ns"
  ip link set veth-$ns netns $ns
  pause
done

# see interfaces in all namespaces
for ns in red blue green yellow; do
  echo "$MY_LOG_SIGN see interfaces in $ns"
  ip netns exec $ns ip addr show
  pause
done

# assign ip addresses to the interfaces
i=0
for ns in red blue green yellow; do
  IP_FOR_NS=${IPS[i]}
  echo "$MY_LOG_SIGN assign ip address $IP_FOR_NS to the interface for $ns"
  ip netns exec $ns ip addr add $IP_FOR_NS/24 dev veth-$ns
  pause
  i=$((i+1))
done

# bring up the interfaces
for ns in red blue green yellow; do
  echo "$MY_LOG_SIGN bring up the interface for veth-$ns"
  ip netns exec $ns ip link set veth-$ns up
  pause
done

# bring up the interfaces in the host side
for ns in red blue green yellow; do
  echo "$MY_LOG_SIGN bring up the interface for veth-$ns-br"
  ip link set veth-$ns-br up
  pause
done

# see route in all namespaces
for ns in red blue green yellow; do
  echo "$MY_LOG_SIGN see route in $ns"
  ip netns exec $ns ip route
  pause
done

# see interfaces in all namespaces
for ns in red blue green yellow; do
  echo "$MY_LOG_SIGN see interfaces in $ns"
  ip netns exec $ns ip addr show
  pause
done

# check
echo "$MY_LOG_SIGN check if firewall bridge traffic is enabled ( 1 = enabled, 0 = disabled)"
IPTABLES_VALUE=$(cat /proc/sys/net/bridge/bridge-nf-call-iptables)
echo "$MY_LOG_SIGN cat /proc/sys/net/bridge/bridge-nf-call-iptables"
cat /proc/sys/net/bridge/bridge-nf-call-iptables
pause
IP6TABLES_VALUE=$(cat /proc/sys/net/bridge/bridge-nf-call-ip6tables)
echo "$MY_LOG_SIGN cat /proc/sys/net/bridge/bridge-nf-call-ip6tables"
cat /proc/sys/net/bridge/bridge-nf-call-ip6tables
pause
ARPTABLES_VALUE=$(cat /proc/sys/net/bridge/bridge-nf-call-arptables)
echo "$MY_LOG_SIGN cat /proc/sys/net/bridge/bridge-nf-call-arptables"
cat /proc/sys/net/bridge/bridge-nf-call-arptables
pause

# if its 1, set to 0
if [ $IPTABLES_VALUE -eq 1 ]; then
echo "$MY_LOG_SIGN set /proc/sys/net/bridge/bridge-nf-call-iptables to 0"
sysctl -w net.bridge.bridge-nf-call-iptables=0
pause
fi

# if [ $IP6TABLES_VALUE -eq 1 ]; then
# echo "$MY_LOG_SIGN set /proc/sys/net/bridge/bridge-nf-call-ip6tables to 0"
# sysctl -w net.bridge.bridge-nf-call-ip6tables=0
# pause
# fi

# if [ $ARPTABLES_VALUE -eq 1 ]; then
# echo "$MY_LOG_SIGN set /proc/sys/net/bridge/bridge-nf-call-arptables to 0"
# sysctl -w net.bridge.bridge-nf-call-arptables=0
# pause
# fi




# ping in a loop
i=1
for ns in blue green yellow; do
  echo "$MY_LOG_SIGN try ping red->$ns, ip ${IPS[i]}!"
  ip netns exec red ping -c 1 ${IPS[i]}
  echo "$MY_LOG_SIGN from what interface red->$ns, ip ${IPS[i]}!"
  ip netns exec red ip route get ${IPS[i]}
  pause
  i=$((i+1))
done



# see arp in all namespaces
for ns in red blue green yellow; do
  echo "$MY_LOG_SIGN see arp in $ns"
  ip netns exec $ns arp
  pause
done



# to ping locahost / 127.0.0.1 in ns, we need to bring the lo up
# try ping when its down with fast timeout cause its gonna fail any way 
for ns in red blue green yellow; do
  echo "$MY_LOG_SIGN try ping $ns->localhost, ip 127.0.0.1!"
  ip netns exec $ns ping -c 1 127.0.0.1
  pause
done

for ns in red blue green yellow; do
  echo "$MY_LOG_SIGN bring up the lo interface for $ns"
  ip netns exec $ns ip link set lo up
  pause
done

for ns in red blue green yellow; do
  echo "$MY_LOG_SIGN try ping $ns->localhost, ip 127.0.0.1!"
  ip netns exec $ns ping -c 1 127.0.0.1
  pause
done


# connectivity from host -> red
echo "$MY_LOG_SIGN ping host -> red"
ping -c 1 ${IPS[0]}
echo "$MY_LOG_SIGN from what interface host -> red"
ip route get ${IPS[0]}
pause

# assign an ip to the bridge
echo "$MY_LOG_SIGN assign an ip to the bridge"
ip addr add $V_NET_0_IP/24 dev v-net-0
pause

echo "$MY_LOG_SIGN see interfaces on the host now"
ip addr show
pause

# ping again host -> red
echo "$MY_LOG_SIGN ping host -> red"
ping -c 1 ${IPS[0]}
pause

# connectivity from red -> host
echo "$MY_LOG_SIGN ping red -> host $HOST_IP"
ip netns exec red ping -c 1 $HOST_IP
echo "$MY_LOG_SIGN from what interface red -> host $HOST_IP"
ip netns exec red ip route get $HOST_IP
pause

# add a route entry to reach host network from the bridge interface ip address
for ns in red blue green yellow; do
  echo "$MY_LOG_SIGN add a route entry $HOST_NETWORK to $ns via the bridge interface ip address $V_NET_0_IP"
  ip netns exec $ns ip route add $HOST_NETWORK via $V_NET_0_IP
  pause
done

# connectivity from each ns -> host
for ns in red blue green yellow; do
  echo "$MY_LOG_SIGN ping $ns -> host $HOST_IP"
  ip netns exec $ns ping -c 1 $HOST_IP
  echo "$MY_LOG_SIGN from what interface $ns -> host $HOST_IP"
  ip netns exec $ns ip route get $HOST_IP
  pause
done

# do this only if REACHABLE_FROM_HOST is set
if [ -n "$REACHABLE_FROM_HOST" ]; then
  echo "$MY_LOG_SIGN ping $REACHABLE_FROM_HOST -> host $HOST_IP"
  ping -c 1 $REACHABLE_FROM_HOST
  pause
  # but can we ping it from ns? check only for red ns
  for ns in red; do
    echo "$MY_LOG_SIGN ping $ns -> $REACHABLE_FROM_HOST"
    ip netns exec $ns ping -c 1 $REACHABLE_FROM_HOST
    echo "$MY_LOG_SIGN from what interface $ns -> $REACHABLE_FROM_HOST"
    ip netns exec $ns ip route get $REACHABLE_FROM_HOST
    pause
  done
  echo "$MY_LOG_SIGN we didnt get response back, need to add a rule to ip tables, means to replace the source address on all packets coming from the source network ($NS_NETWORK) with its own ip address ($V_NET_0_IP), anyone receiving these packets outside the network will think that they are coming from the host and not from within the namespaces"
  TABLE="nat"
  CHAIN="POSTROUTING"
  SOURCE="$NS_NETWORK"
  TARGET="MASQUERADE"
  # Check if the rule exists 
  if iptables --table "$TABLE" --check "$CHAIN" --source "$SOURCE" --jump "$TARGET" 2>/dev/null; then
    echo "$MY_LOG_SIGN Rule already exists: --table $TABLE --check $CHAIN --source $SOURCE --jump $TARGET"
  else
    echo "$MY_LOG_SIGN Adding rule: --table $TABLE --append $CHAIN --source $SOURCE --jump $TARGET"
    IPTABLES_NAT_POSTROUTING_MASQUERADE_CHANGED=true
    iptables --table "$TABLE" --append "$CHAIN" --source "$SOURCE" --jump "$TARGET"
  fi
  pause
  TABLE="filter"
  CHAIN="FORWARD"
  IN_INTERFACE="v-net-0"
  OUT_INTERFACE="ens5"
  TARGET="ACCEPT"
  # Check if the rule exists 
  if iptables --table "$TABLE" --check "$CHAIN" --in-interface "$IN_INTERFACE" --out-interface "$OUT_INTERFACE" --jump "$TARGET" 2>/dev/null; then
    echo "$MY_LOG_SIGN Rule already exists: --table $TABLE --check $CHAIN --in-interface $IN_INTERFACE --out-interface $OUT_INTERFACE --jump $TARGET"
  else
    echo "$MY_LOG_SIGN Adding rule: --table $TABLE --append $CHAIN --in-interface $IN_INTERFACE --out-interface $OUT_INTERFACE --jump $TARGET"
    IPTABLES_FILTER_FORWARD_ACCEPT_CHANGED=true
    iptables --table "$TABLE" --append "$CHAIN" --in-interface "$IN_INTERFACE" --out-interface "$OUT_INTERFACE" --jump "$TARGET"
  fi
  pause
  TABLE="filter"
  CHAIN="FORWARD"
  IN_INTERFACE="ens5"
  OUT_INTERFACE="v-net-0"
  TARGET="ACCEPT"
  # Check if the rule exists 
  if iptables --table "$TABLE" --check "$CHAIN" --in-interface "$IN_INTERFACE" --out-interface "$OUT_INTERFACE" --match state --state RELATED,ESTABLISHED --jump "$TARGET" 2>/dev/null; then
    echo "$MY_LOG_SIGN Rule already exists: --table $TABLE --check $CHAIN --in-interface $IN_INTERFACE --out-interface $OUT_INTERFACE --match state --state RELATED,ESTABLISHED --jump $TARGET"
  else
    echo "$MY_LOG_SIGN Adding rule: --table $TABLE --append $CHAIN --in-interface $IN_INTERFACE --out-interface $OUT_INTERFACE --match state --state RELATED,ESTABLISHED --jump $TARGET"
    IPTABLES_FILTER_FORWARD_RELATED_ESTABLISHED_ACCEPT_CHANGED=true
    iptables --table "$TABLE" --append "$CHAIN" --in-interface "$IN_INTERFACE" --out-interface "$OUT_INTERFACE" --match state --state RELATED,ESTABLISHED --jump "$TARGET"
  fi
  pause
  # do again the ping test
  for ns in red blue green yellow; do
    echo "$MY_LOG_SIGN ping $ns -> $REACHABLE_FROM_HOST"
    ip netns exec $ns ping -c 1 $REACHABLE_FROM_HOST
    echo "$MY_LOG_SIGN from what interface $ns -> $REACHABLE_FROM_HOST"
    ip netns exec $ns ip route get $REACHABLE_FROM_HOST
    pause
  done
  # can we reach 8.8.8.8  form the ns ?  check only from red
  for ns in red; do
    echo "$MY_LOG_SIGN ping $ns -> 8.8.8.8"
    ip netns exec $ns ping -c 1 8.8.8.8
    echo "$MY_LOG_SIGN from what interface $ns -> 8.8.8.8"
    ip netns exec $ns ip route get 8.8.8.8
    pause
  done

  # for each ns add a route of a default gateway
  for ns in red blue green yellow; do
    echo "$MY_LOG_SIGN add a route of a default gateway to $ns"
    ip netns exec $ns ip route add default via $V_NET_0_IP
    pause
  done

  # do the ping test again, from all ns
  for ns in red blue green yellow; do
    # first see route table
    echo "$MY_LOG_SIGN see route table in $ns"
    ip netns exec $ns ip route
    pause
    echo "$MY_LOG_SIGN ping $ns -> 8.8.8.8"
    ip netns exec $ns ping -c 1 8.8.8.8
    echo "$MY_LOG_SIGN from what interface $ns -> 8.8.8.8"
    ip netns exec $ns ip route get 8.8.8.8
    pause
  done
  # to reach from REACHABLE_FROM_HOST to ns:
  # 1. add a route to reach ns from REACHABLE_FROM_HOST
  # or
  # 2. add in nat table PREROUTING rule from port 8080 to ns-ip:8080 --jump DNAT ( port forward basically !)
  # sudo iptables --table nat --append PREROUTING --protocol tcp --destination-port 8080 --jump DNAT --to-destination 192.168.15.1:8080
  
  # cleanup for changes in iptables
  if [ -n "$IPTABLES_NAT_POSTROUTING_MASQUERADE_CHANGED" ]; then
    TABLE="nat"
    CHAIN="POSTROUTING"
    SOURCE="$NS_NETWORK"
    TARGET="MASQUERADE"
    iptables --table "$TABLE" --delete "$CHAIN" --source "$SOURCE" --jump "$TARGET"
    # check if rule exists after deletion
    echo "$MY_LOG_SIGN check if chain $CHAIN in table $TABLE for target $TARGET and source $SOURCE exists after deletion"
    iptables --table "$TABLE" --check "$CHAIN" --source "$SOURCE" --jump "$TARGET"
    pause
  fi
  if [ -n "$IPTABLES_FILTER_FORWARD_ACCEPT_CHANGED" ]; then
    TABLE="filter"
    CHAIN="FORWARD"
    IN_INTERFACE="v-net-0"
    OUT_INTERFACE="ens5"
    TARGET="ACCEPT"
    iptables --table "$TABLE" --delete "$CHAIN" --in-interface "$IN_INTERFACE" --out-interface "$OUT_INTERFACE" --jump "$TARGET"
    # check if rule exists after deletion
    echo "$MY_LOG_SIGN check if chain $CHAIN in table $TABLE for target $TARGET and in-interface $IN_INTERFACE and out-interface $OUT_INTERFACE exists after deletion"
    iptables --table "$TABLE" --check "$CHAIN" --in-interface "$IN_INTERFACE" --out-interface "$OUT_INTERFACE" --jump "$TARGET"
    pause
  fi
  if [ -n "$IPTABLES_FILTER_FORWARD_RELATED_ESTABLISHED_ACCEPT_CHANGED" ]; then
    TABLE="filter"
    CHAIN="FORWARD"
    IN_INTERFACE="ens5"
    OUT_INTERFACE="v-net-0"
    TARGET="ACCEPT"
    iptables --table "$TABLE" --delete "$CHAIN" --in-interface "$IN_INTERFACE" --out-interface "$OUT_INTERFACE" --match state --state RELATED,ESTABLISHED --jump "$TARGET"
    # check if rule exists after deletion
    echo "$MY_LOG_SIGN check if chain $CHAIN in table $TABLE for target $TARGET and in-interface $IN_INTERFACE and out-interface $OUT_INTERFACE and match state RELATED,ESTABLISHED exists after deletion"
    iptables --table "$TABLE" --check "$CHAIN" --in-interface "$IN_INTERFACE" --out-interface "$OUT_INTERFACE" --match state --state RELATED,ESTABLISHED --jump "$TARGET"
    pause
  fi
fi




# cleanup

for ns in red blue green yellow; do
  echo "$MY_LOG_SIGN clean up $ns!"
  ip netns del $ns
  pause
done

echo "$MY_LOG_SIGN clean up v-net-0!"
ip link del v-net-0
pause

echo "$MY_LOG_SIGN check interfaces on the host now"
ip addr show
pause

echo "$MY_LOG_SIGN check network namespaces now"
ip netns
pause

# if IPTABLES_VALUE was 1, set it back to 1
if [ $IPTABLES_VALUE -eq 1 ]; then
echo "$MY_LOG_SIGN set /proc/sys/net/bridge/bridge-nf-call-iptables bach to $IPTABLES_VALUE"
sysctl -w net.bridge.bridge-nf-call-iptables=$IPTABLES_VALUE
pause
fi

# # if IP6TABLES_VALUE was 1, set it back to 1
# if [ $IP6TABLES_VALUE -eq 1 ]; then
# echo "$MY_LOG_SIGN set /proc/sys/net/bridge/bridge-nf-call-ip6tables bach to $IP6TABLES_VALUE"
# sysctl -w net.bridge.bridge-nf-call-ip6tables=$IP6TABLES_VALUE
# pause
# fi

# # if ARPTABLES_VALUE was 1, set it back to 1
# if [ $ARPTABLES_VALUE -eq 1 ]; then
# echo "$MY_LOG_SIGN set /proc/sys/net/bridge/bridge-nf-call-arptables bach to $ARPTABLES_VALUE"
# sysctl -w net.bridge.bridge-nf-call-arptables=$ARPTABLES_VALUE
# pause
# fi
