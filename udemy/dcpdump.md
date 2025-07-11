# 🧠 TCPDUMP CHEAT SHEET (Hands-On Quiz Edition)

### 🔧 Basic Syntax

```bash
tcpdump [options] [filter expression]
```

---

## 📦 INTERFACE SELECTION

```bash
tcpdump -D                     # List all interfaces
sudo tcpdump -i eth0           # Capture on eth0
sudo tcpdump -i any            # Capture on all interfaces
```

---

## 🔍 INSPECTION FILTERS

### 🔹 IP / Subnet

```bash
tcpdump -i eth0 host 192.168.1.1
sudo tcpdump -i eth0 net 10.0.0.0/8
```

### 🔹 Protocol

```bash
tcpdump -i eth0 icmp          # Ping
sudo tcpdump -i eth0 tcp      # TCP traffic
sudo tcpdump -i eth0 udp port 53   # DNS
```

### 🔹 Port

```bash
tcpdump -i eth0 port 22       # Any traffic on port 22
sudo tcpdump -i eth0 src port 80
sudo tcpdump -i eth0 dst port 443
```

### 🔹 Direction

```bash
tcpdump -i eth0 src 192.168.1.5
tcpdump -i eth0 dst 8.8.8.8
```

---

## 📄 OUTPUT FORMATTING

```bash
tcpdump -n                    # Don't resolve hostnames
tcpdump -nn                   # Don't resolve hostnames or ports
sudo tcpdump -i eth0 -c 10    # Capture only 10 packets
sudo tcpdump -i eth0 -v       # Verbose
sudo tcpdump -i eth0 -vvv     # Super verbose
```

---

## 💾 SAVE / READ FROM FILE

```bash
sudo tcpdump -i eth0 -w capture.pcap
sudo tcpdump -r capture.pcap
```

---

## 🌐 NAMESPACES

```bash
sudo ip netns exec red tcpdump -i veth-red
sudo ip netns exec blue tcpdump -i veth-blue
```

---

## 🔁 COMMON USE CASES

```bash
sudo tcpdump -i eth0 icmp                     # Capture pings
sudo tcpdump -i eth0 port 80                  # Capture HTTP
sudo tcpdump -i eth0 -n host 10.9.8.8         # No DNS resolution
sudo tcpdump -i any net 192.168.15.0/24       # Observe namespace traffic
```

---

## ⛔ STOPPING

* Press `Ctrl+C` to stop capturing

---

## 🧪 BONUS: WITH TIME STAMPS

```bash
sudo tcpdump -tttt -i eth0
```

---

## 🛠 TIP: COMBINE FILTERS

```bash
sudo tcpdump -i eth0 src net 10.0.0.0/8 and dst port 443
```

---

> ✅ Recommended for debugging iptables + namespace + NAT behavior.
> Use with `ping`, `curl`, `iptables -L -v`, and `ip netns exec` together.
