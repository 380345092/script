#!/bin/bash
#先执行外面的A的循环，然后执行下面的B的循环
#A=1 B=1，A=2 B=1 B=2
for ((A=1;A<=9;A++))
   do
	for ((B=1;B<=$A;B++))
	   do
		echo -n -e "$B*$A=$((A*B)) \t"
	done
	echo
done
