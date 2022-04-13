#!/bin/bash

#read -p "NUM: " num1
#while [ $num1 -gt 0 ]
#   do
#	echo " $num1大于0 "
#        sleep 3
#done

while [ ! -e /tmp/luwei ]
   do
	echo "not found /tmp/luwei"
	sleep 3
done
