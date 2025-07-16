pause() {
  read -p "Press Enter to continue..."
}
REACHABLE_HOST_IP=$1

echo "lets ping the host $REACHABLE_HOST_IP"
ping -c 3 $REACHABLE_HOST_IP
pause

echo "its reachable, we want to ping a name instead of ip"
echo "$REACHABLE_HOST_IP host-friend" >> /etc/hosts
pause

echo "ping host-friend"
ping -c 3 host-friend
pause

echo "clean up"
echo "host-friend" | xargs -I {} sed -i '/{}$/d' /etc/hosts
echo "removed host-friend from /etc/hosts"
cat /etc/hosts
pause

echo "$REACHABLE_HOST_IP host-friend.myfriends.com" >> /etc/hosts
echo "ping host-friend.myfriends.com"
echo "added host-friend.myfriends.com to /etc/hosts"
cat /etc/hosts
pause


ping -c 3 host-friend.myfriends.com
pause

echo "remove host-friend.myfriends.com from /etc/hosts"
echo "host-friend.myfriends.com" | xargs -I {} sed -i '/{}$/d' /etc/hosts
echo "removed host-friend.myfriends.com from /etc/hosts"
cat /etc/hosts
pause


# echo "search myfriends.com" >> /etc/resolv.conf
# echo "added myfriends.com to /etc/resolv.conf"
# cat /etc/resolv.conf
# pause

# echo "we want to ping just host-friend without the suffix"
# echo "ping host-friend"
# ping -c 3 host-friend
# pause

# echo "clean up"
# echo "myfriends.com" | xargs -I {} sed -i '/{}$/d' /etc/resolv.conf
# echo "removed myfriends.com from /etc/resolv.conf"
# cat /etc/resolv.conf
# pause

