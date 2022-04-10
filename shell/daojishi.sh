#!/bin/bash
for time in `seq 9 -1 0`;do
   echo -n -e "\b$time"                   #  -n 不换行   -e 保留特殊字符含义，比如保留/b
   sleep 1
done

echo                                        #最后输出一个空格，美观
