\#!/bin/bash

RED='\033\[0;31m'
GREEN='\033\[0;32m'
YELLOW='\033\[0;33m'
CYAN='\033\[0;36m'
BLUE='\033\[0;34m'
BOLD='\033\[1m'
RESET='\033\[0m'

if \[ -z "\$1" ]; then
echo "Usage: \$0 \<IP/CIDR/IP-range>"
exit 1
fi

IP\_RANGE="\$1"

echo "\[\*] Scanning for live hosts in \$IP\_RANGE..."
sudo nmap -sn -oN NmapAllLiveIPs "\$IP\_RANGE" > /dev/null

grep -i "MAC Address.\*VirtualBox|VirtualBox.\*MAC Address" -B 2 NmapAllLiveIPs |&#x20;
grep "Nmap scan report for" | awk '{print \$5}' > TempHosts.txt

sudo nmap -iL TempHosts.txt -oN NmapTargetsScan > /dev/null
grep -B 3 SERVICE NmapTargetsScan | grep "Nmap scan report for" | cut -d " " -f 5 > NmapTargets
rm TempHosts.txt
sudo rm NmapTargetsScan

TARGETS=\$(cat NmapTargets)
if \[ -z "\$TARGETS" ]; then
echo "\[!] No valid targets with open ports found."
exit 1
fi

for TARGET\_IP in \$TARGETS; do
echo -e "\[+] \${BOLD}\${CYAN}Target IP: \${TARGET\_IP}\${RESET}"

echo "\[\*] Scanning all ports on \$TARGET\_IP..."
sudo nmap -vv -T4 -O -p- -oN NmapPortsNoEnum "\$TARGET\_IP" > /dev/null

PORTS\_WITH\_SERVICES=""
LIVE\_PORTS=""
while IFS= read -r line; do
PORT=\$(echo \$line | cut -d '/' -f 1)
PROTOCOL=\$(echo \$line | cut -d '/' -f 2 | cut -d ' ' -f 1)
SERVICE=\$(echo \$line | cut -d ' ' -f 3)
\[ -z "\$SERVICE" ] && SERVICE="Unknown"
PORTS\_WITH\_SERVICES+="\$PORT(\$SERVICE), "
LIVE\_PORTS+="\$PORT,"
done <<< "\$(grep ^\[0-9] NmapPortsNoEnum)"

PORTS\_WITH\_SERVICES="\${PORTS\_WITH\_SERVICES%, }"
LIVE\_PORTS="\${LIVE\_PORTS%,}"
echo -e "\[+] \${BOLD}\${YELLOW}Live Open Ports: \${PORTS\_WITH\_SERVICES}\${RESET}"

OS\_NAME=\$(grep "OS details:" NmapPortsNoEnum | cut -d ':' -f2- | xargs)
\[ -z "\$OS\_NAME" ] && OS\_NAME="Unknown"
echo -e "\[+] \${BOLD}\${GREEN}Detected OS:\${RESET} \$OS\_NAME"

echo "\[\*] Enumerating open ports..."
sudo nmap -vv -T4 -sV -sC -p"\$LIVE\_PORTS" -oN NmapPortsEnum "\$TARGET\_IP" > /dev/null 2>&1

echo -e "\n\[+] \${BOLD}\${BLUE}Nmap Enumeration Output for \$TARGET\_IP:\${RESET}"
cat NmapPortsEnum
echo -e "\n----------------------------------------\n"
done
