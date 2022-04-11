#!/bin/bash

for ((i=1;i<10;i++))
   do
	if [ $i -eq 5 ];then
		#contiune表示本次循环到此结束，继续进行下一次循环
		continue
	fi
	
    echo $i
done
