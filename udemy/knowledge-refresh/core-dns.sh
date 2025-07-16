pause() {
  read -p "Press Enter to continue..."
}
REACHABLE_HOST_IP=$1
echo "Checking if CoreDNS is installed..."
if ! command -v coredns >/dev/null 2>&1; then
  echo "CoreDNS not found, downloading and installing..."
  pause
  wget https://github.com/coredns/coredns/releases/download/v1.12.2/coredns_1.12.2_linux_amd64.tgz
  tar --gzip --extract --verbose --file coredns_1.12.2_linux_amd64.tgz
  chmod +x coredns
  mv coredns /usr/local/bin/
  coredns -version
  which coredns
else
  echo "CoreDNS is already installed."
  coredns -version
  which coredns
fi
pause

echo "create a Corefile"
cat <<EOF > Corefile
. {
    hosts {
        $REACHABLE_HOST_IP my-friend
        fallthrough
    }

    forward . 8.8.8.8
    log
    errors
}
EOF

echo "in anotehr terminal, start coredns with coredns -dns.port=1053"
pause

echo "test is with dig"
dig @127.0.0.1 -p 1053 my-friend
pause
dig @127.0.0.1 -p 1053 google.com
pause



