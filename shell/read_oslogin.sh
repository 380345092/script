#!/bin/bash
clear

echo "Centos Linux 7 (Core)"
echo -e "Kernel `uname -r` an `uname -m`\n"

echo -n -e "$HOSTNAME login: "
read user
echo -n -e "passwd: "
read -s passwd
echo

