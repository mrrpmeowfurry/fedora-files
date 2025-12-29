#!/usr/bin/env bash

# ────────────────────────────────────────────────
# Fedora 42 MOTD Script by Mind (Phapoom Saksri)
# Shows system info, storage summary, and reminders
# ────────────────────────────────────────────────

# Print ASCII banner if available

# Gather system info
HOSTNAME=$(hostname)
DISTRO=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
KERNEL=$(uname -r)
UPTIME=$(uptime -p | sed 's/^up //')
#CPU=$(lscpu | grep 'Model name:' | sed 's/Model name:\s*//')
CPU=$(LC_ALL=C lscpu | awk -F: '/Model name/ {print $2; exit}' | sed 's/^ *//')
RAM_USED=$(free -h | awk '/Mem:/ {print $3}')
RAM_TOTAL=$(free -h | awk '/Mem:/ {print $2}')
SSD_USAGE=$(df -h /dev/nvme0n1p3 | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')
HDD_USAGE=$(df -h /dev/sdb | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')
HDD_USAGE2=$(df -h /dev/sda1 | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')
USERS=$(who | awk '{print $1}' | sort | uniq | paste -sd "," -)

# Use colors for readability
BOLD=$(tput bold)
RESET=$(tput sgr0)
CYAN=$(tput setaf 6)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)

# Header
echo "${BOLD}${CYAN}Welcome back, Evelyn Chevalier!${RESET}"

if [ -f /etc/motd-ascii-art.txt ]; then
    colors=(
        "38;2;91;206;250"   # light blue
        "38;2;245;169;184" # pink
        "38;2;255;255;255" # white
        "38;2;245;169;184" # pink
        "38;2;91;206;250"  # light blue
    )

    i=0
    while IFS= read -r line; do
        c=${colors[$((i % ${#colors[@]}))]}
        echo -e "\e[${c}m$line\e[0m"
        i=$((i+1))
    done < /etc/motd-ascii-art.txt

    echo ""
fi


echo "${YELLOW}${DISTRO}${RESET} | Kernel: ${CYAN}${KERNEL}${RESET}"
echo "Uptime: ${UPTIME}"

# System resources
echo ""
echo "${BOLD}System Summary:${RESET}"
echo "  CPU                  : ${CPU}${RESET}"
echo "  Memory               : ${RAM_USED} ${RESET}/ ${RAM_TOTAL}${RESET}"
echo "  SSD (/dev/nvme0n1p3) : ${SSD_USAGE}${RESET}"
echo "  HDD (/dev/sdb)       : ${HDD_USAGE}${RESET}"
echo "  HDD (/dev/sda1)      : ${HDD_USAGE2}${RESET}"
echo "  Users                : ${USERS:-none}${RESET}"
echo ""

# Sysadmin lecture
cat <<'EOF'
Alias:
  • otd - Start OpenTabletDriver Service.
  • fix - Fix vesktop not starting
  • ttt - SSH TechTransThai
  • nbo - SSH NBO

EOF
