# IPTABLES CHEAT SHEET

This cheat sheet provides practical and comprehensive `iptables` usage for inspecting, filtering, and forwarding traffic in Linux environments (including with network namespaces).

---

## 📌 Basics

### List Rules

```bash
iptables -L                  # List rules in the filter table (default)
iptables -L -v               # Add packet and byte counters
iptables -L -n               # Do not resolve DNS
iptables -t nat -L           # List rules in the NAT table
iptables -t raw -L           # List rules in the RAW table
```

### Flush Rules (Clear Table)

```bash
iptables -F                  # Flush all filter table rules
iptables -t nat -F           # Flush NAT table
```

### Delete Specific Rule

```bash
iptables -D INPUT 1          # Delete 1st rule in INPUT chain
```

### Insert/Append Rule

```bash
iptables -A INPUT -j DROP                # Append rule to drop all input
iptables -I INPUT 1 -j ACCEPT            # Insert accept rule at position 1
```

---

## 🧱 Tables and Chains

| Table    | Purpose                      | Chains                                                    |
| -------- | ---------------------------- | --------------------------------------------------------- |
| `filter` | Packet filtering (default)   | `INPUT`, `FORWARD`, `OUTPUT`                              |
| `nat`    | NAT (address translation)    | `PREROUTING`, `POSTROUTING`, `OUTPUT`                     |
| `raw`    | Disable connection tracking  | `PREROUTING`, `OUTPUT`                                    |
| `mangle` | Packet alteration (TTL, TOS) | `PREROUTING`, `POSTROUTING`, `INPUT`, `OUTPUT`, `FORWARD` |

---

## 🔀 Common Rules

### Allow All on Loopback

```bash
iptables -A INPUT -i lo -j ACCEPT
```

### Allow Established Connections

```bash
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```

### Drop All Input (Default Policy)

```bash
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
```

---

## 🔧 Forwarding & Bridging

### Allow Traffic via Virtual Bridge (v-net-0)

```bash
iptables -A FORWARD -i v-net-0 -j ACCEPT
iptables -A FORWARD -o v-net-0 -j ACCEPT
```

### Allow Pings (ICMP)

```bash
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
```

### Drop All by Default, Then Allow Specific

```bash
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

iptables -A INPUT -p tcp --dport 22 -j ACCEPT      # Allow SSH
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```

---

## 🔎 Logging

```bash
iptables -A INPUT -j LOG --log-prefix "IPTables-Dropped: " --log-level 4
```

---

## 🧹 Reset All

```bash
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
```

---

## 🧪 Inspecting Traffic (Useful for Debug)

```bash
watch -n1 iptables -L -v -n
```

Or see packet counters:

```bash
iptables -nvL
```

Use with network namespaces:

```bash
ip netns exec red iptables -L -v
```

---

This cheat sheet is meant to stay open during your quiz/lab. Use it actively!
