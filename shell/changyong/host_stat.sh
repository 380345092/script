#!/bin/bash
for ((i=1;i<4;i++));do
#测试代码
#这里把 ping_count赋予全局变量，如果不export的话，执行命令的时候会把ping_count作为一条命令执行，从未报错，赋予变量后就可以了，或者set手动设置变量
# $1是指命令后面带的第一个参数，也就是需要ping的ip
   if ping -c 1 $1 &>/dev/null;then
	export  ping_count"$i"=0
   else
	export  ping_count"$i"=1
   fi
#时间间隔
   sleep 1
done

#3次ping失败报警
if [ $ping_count1 -eq $ping_count2 ] && [ $ping_count2 -eq $ping_count3 ] && [ $ping_count1 -eq 1 ];then
   echo "$1 is down"
else
   echo "$1 is up"
fi

#因前面做了全局赋值，这里解除赋值
unset ping_count[1,3]
