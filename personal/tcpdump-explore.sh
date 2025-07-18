pause() {
  read -p "Press Enter to continue..."
}

MY_LOG_SIGN="=========>"


echo "$MY_LOG_SIGN ip route get 127.0.0.1 to see waht interface will be used to make calls to 127.0.0.1"
echo "$MY_LOG_SIGN capture interface lo port 8080"
echo "$MY_LOG_SIGN python3 -m http.server 8080"
pause

echo "$MY_LOG_SIGN tcpdump -A --interface lo port 8080"
pause

echo "$MY_LOG_SIGN curl http://localhost:8080"
echo "$MY_LOG_SIGN curl http://<your private ip>:8080"
echo "$MY_LOG_SIGN curl --interface ens5 http://<your private ip>:8080"
pause


echo "$MY_LOG_SIGN now make call to <machinepublicip>:8080, and see if it was capptured!"
echo "$MY_LOG_SIGN no, cause it goes from anotehr interface, not lo"
echo "$MY_LOG_SIGN tcpdump -A --interface ens5 port 8080"
echo "$MY_LOG_SIGN now send request from the internet, see its captured"
echo "$MY_LOG_SIGN now curl localhost:8080, see its not catured"
pause

echo "$MY_LOG_SIGN ss -tupn"
echo "$MY_LOG_SIGN want to know the interface and source ip to get to some ip? check ip route get <destination ip>"
pause

echo "$MY_LOG_SIGN ip route get 127.0.0.1"
pause

echo "$MY_LOG_SIGN ip route get 172.17.0.4 ( ip in docker )"
pause

echo "$MY_LOG_SIGN ip route get 172.18.0.4 ( ip in kind network )"
pause


echo "$MY_LOG_SIGN run docker container: docker run -itd --name net-tools tehilathestudent/net-tools"
pause

echo "$MY_LOG_SIGN ip route get 172.17.0.2 ( ip in docker )"
pause

echo "$MY_LOG_SIGN now run contaienr1 and container2, and make a curl cal from container1 to container2"
pause

echo "$MY_LOG_SIGN tcpdump -A --interface docker0 port 8080"
pause

echo "$MY_LOG_SIGN tcpdump --interface docker0"
echo "$MY_LOG_SIGN and make a ping from host to container, notice the source and dest ip"
pause

echo "$MY_LOG_SIGN now make a ping from container to host, notice the source and dest ip"
pause

echo "$MY_LOG_SIGN now make a ping from container to container, notice the source and dest ip"
pause


echo "$MY_LOG_SIGN use -n ( numeric ) any time, or -v ( verbose ) when you want!, use -nn to not resolve port names and ip names "
pause

echo "$MY_LOG_SIGN run 8080 in contauner, in host and curl: host-> container, container-> host(hostip),container->host(docker0 ip), container-> container, see source ip:port and dest ip:port"
pause

echo "$MY_LOG_SIGN we are gonna see more filtering options to tcpdump, check man tcpdump for more options"
pause

echo "$MY_LOG_SIGN tcpdump -nn --interface any port 8080"
pause

echo "$MY_LOG_SIGN run python on 8080 ib container and in host"
pause

echo "$MY_LOG_SIGN curl outside->ec2-pub-ip, host->container, container->host, container->container"
pause

echo "$MY_LOG_SIGN notice please to the interface used, source and dest ip, and ist it In or Out"
pause

echo "$MY_LOG_SIGN source ip is interface ip!!!!!! ip addr show , to see it!!!, but the interface is decided in the routing table, you can controll the souce ip though"
pause

echo "$MY_LOG_SIGN lets try reach with loopback -> contaienr, wont work, curl --interface 127.0.0.1 172.17.0.2:8080"
pause

echo "$MY_LOG_SIGN  run python on 8080 in host"
pause

echo "$MY_LOG_SIGN curl locahost:8080"
pause

echo "$MY_LOG_SIGN curl --interface docker0 localhost:8080"
pause

echo "$MY_LOG_SIGN curl --interface ens5 localhost:8080"
pause


echo "$MY_LOG_SIGN curl --interface docker0 10.9.8.10:8080"
pause

echo "$MY_LOG_SIGN curl --interface ens5 10.9.8.10:8080"
pause


echo "$MY_LOG_SIGN curl --interface docker0 172.17.0.1:8080"
pause

echo "$MY_LOG_SIGN you could do all the above with second ec2 as well, of course"
pause

echo "$MY_LOG_SIGN  sudo tcpdump -nn  port 8080, than access ec2-pub-ip from work comp and local laptop"

echo "$MY_LOG_SIGN we try the host filter now, host is the source/dest ip, note that not specifying interface wont be any but the ens5 interface, so specify any,  run again python 8080 on the host"
pause

echo "$MY_LOG_SIGN tcpdump -nn --interface any host <local laptop ip, exampple 212.76.123.65> and port 8080 ( see local laptop ip by sudo tcpdump -nn host 10.9.8.10, you will see the ssh)"
pause



echo "$MY_LOG_SIGN now reach the public-ec2-ip, "
pause

echo "$MY_LOG_SIGN filter by host: 127.0.0.1, 10.9.8.10, 172.17.0.1, and try reach from different sources"
pause

echo "$MY_LOG_SIGN dst host  src host is to see by source / dst ip , same like port , port is to see by source / dst port, src port is to see by source port, dst port is to see by destination port"
pause

echo "$MY_LOG_SIGN filtering by protocol  "
pause
echo "$MY_LOG_SIGN sudo tcpdump icmp           # ping"
pause
echo "$MY_LOG_SIGN sudo tcpdump tcp"
pause
echo "$MY_LOG_SIGN sudo tcpdump udp"
pause
echo "$MY_LOG_SIGN sudo tcpdump arp"
pause

echo "$MY_LOG_SIGN sudo tcpdump net 192.168.1.0/24"
pause


echo "$MY_LOG_SIGN sudo tcpdump inbound"
pause
echo "$MY_LOG_SIGN sudo tcpdump outbound"
pause



✅ How to simulate domain-based filtering
🔹 Step 1: Resolve the domain to IP(s)
Use dig or nslookup:

dig +short example.com
# or
nslookup example.com

------------------
🔎 Bonus: See DNS lookups to a domain
If you want to see the DNS query for a domain:

sudo tcpdump -i eth0 port 53 -n -v
Then run:
curl http://example.com
---------------------------

echo "$MY_LOG_SIGN "
pause









