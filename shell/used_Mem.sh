#!/bin/bash
used=`free '-m' | grep Mem | awk -F'[ ]+' '{print $3}' `   #统计used内存并赋值给used  赋值一定要用``反引号，大写的~
total=`free '-m' | grep Mem | awk -F'[ ]+' '{print $2}' `  #统计total内存并赋值给used  赋值一定要用``反引号，大写的~
echo "当前内存使用率：`echo "scale=2;$used*100/$total"| bc`%"
#计算内存使用率，保留两位小数
#需要加其他文字和%百分号，所以用``让echo "scale=2;$used*100/$total"| bc  先执行，最后输出结果
