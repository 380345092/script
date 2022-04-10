#!/bin/bash
clear

echo -n -e "Login: "
read user
echo -n -e "Passwd: "
read -s -t5 -n6 passwd
echo
echo "username: $user    password: $passwd "
