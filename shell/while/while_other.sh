#!/bin/bash
#如果不想执行某段代码，则用a1 () {}的方式，被括号起来的代码不会被执行
#打印1-9，当数值为5时停止循环
a1 () {
i=1
while [ $i -lt 10 ]
   do
	echo $i
	if [ $i -eq 5 ];then
		break
	fi
	i=$((i+1))
done
}

a2 () {
#打印1-9，当数值为5时跳过当前循环
i=0
while [ $i -lt 10 ]
   do
	i=$((i+1))
	if [ $i -eq 5 ];then
		continue
	fi 
#如果i=9 停止输出
	if [ $i -eq 9 ];then
		break
	else
   		echo $i
		sleep 1
	fi
done
}

n=1
while [ $n -lt 10 ]
   do
	for (( m=1;m<=$n;m++ ))
	   do
		echo -n -e "$m * $n = $((m*n))\t"
	done
	echo
	n=$((n+1))
done
