#!/bin/bash

for (( n=10,m=0;n>0,m<10;n--,m++ ))
   do
	echo -e "$n\t$m"
	sleep 1
done
