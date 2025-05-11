# Cybersecurity Scripts

A collection of custom-written scripts for cybersecurity purposes.

---

## 🛠️ Currently Available Script

### `naio.sh` – Nmap All-In-One Scanner

A Bash script that automates a full Nmap workflow, designed to identify live hosts, filter out virtual machines (VirtualBox), enumerate open ports, detect operating systems, and run basic service detection — all in one go.

#### 🔍 Features
- Accepts IP, CIDR, or IP range as input
- Scans for live hosts and filters VirtualBox MAC addresses
- Detects target IPs with open ports
- Performs:
  - Full port scan
  - OS detection
  - Service and version enumeration
  - Default script scan
- Summarizes live ports and OS per host
- Outputs final Nmap enumeration results for each target

#### 🚀 Usage
```bash
chmod +x naio.sh
./naio.sh <IP/CIDR/IP-range>
````

#### 📌 Example

```bash
./naio.sh 192.168.1.0/24
```

#### ⚠️ Requirements

* `nmap` must be installed
* Root/sudo privileges required for certain scan types
* Tested on Kali Linux

---

## 🧾 License

This project is licensed under the [MIT License](LICENSE).
Free to use, modify, and distribute — but **no warranties or guarantees** are provided.

---

> ⚠️ These tools are for educational and authorized testing purposes only. Do **NOT** use them on systems without explicit permission.
