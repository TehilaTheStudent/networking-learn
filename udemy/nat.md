# 🧠 IPTables NAT Cheat Sheet

This cheat sheet covers practical and comprehensive `iptables` NAT use for labs and quizzes, including SNAT, DNAT, masquerading, and rule inspection.

---

## 🔍 View NAT Rules

```bash
iptables -t nat -L -n -v   / iptables --table nat --list --numeric --verbose       # List all NAT rules with counters
iptables -t nat -S       / iptables --table nat --list-rules         # Show NAT rules in iptables-save style
```

---

## 📋 NAT Chains

| Chain         | Applied When...                          | Typical Use      |
| ------------- | ---------------------------------------- | ---------------- |
| `PREROUTING`  | Before routing decision                  | DNAT             |
| `POSTROUTING` | After routing decision                   | SNAT, MASQUERADE |
| `OUTPUT`      | Locally generated packets before routing | Local DNAT       |

---

## 🌐 Masquerading (Dynamic SNAT)

```bash
iptables -t nat -A POSTROUTING -s 192.168.15.0/24 -o eth0 -j MASQUERADE
```

* Used when the external IP is dynamic (e.g., for internet access).
* Requires IP forwarding to be enabled:

```bash
echo 1 > /proc/sys/net/ipv4/ip_forward
```

---

## 📤 Static SNAT (Fixed Source IP)

```bash
iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j SNAT --to-source 203.0.113.5
```

* Use this when you know your external IP.

---

## 📥 DNAT (Port Forwarding / Incoming Redirect)

```bash
iptables -t nat -A PREROUTING -d 203.0.113.5 -p tcp --dport 8080 -j DNAT --to-destination 192.168.1.100:80
```

* Useful for port forwarding from host to namespace or container.

---

## 🔁 Local DNAT (localhost to namespace)

```bash
iptables -t nat -A OUTPUT -p tcp -d 127.0.0.1 --dport 8080 -j DNAT --to-destination 10.0.0.2:80
```

* Redirects local connections to another namespace or host.

---

## 🧹 Deleting NAT Rules

```bash
iptables -t nat -D POSTROUTING -s 192.168.15.0/24 -o eth0 -j MASQUERADE
```

---

## 🧼 Flush NAT Table

```bash
iptables -t nat -F
```

---

## 🧪 Testing Tips

* Always check IP forwarding:

  ```bash
  cat /proc/sys/net/ipv4/ip_forward
  ```
* Confirm interface name:

  ```bash
  ip a
  ```
* Use `tcpdump` to debug packet flow:

  ```bash
  tcpdump -i eth0 -nn
  ```
* Combine with route checks:

  ```bash
  ip route
  ```

---

This cheat sheet pairs well with the IPTables filter rules cheat sheet.
