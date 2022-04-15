#!/bin/bash

for ((;;))                       #无线循环
   do 
      ping -c1 $1 &>/dev/null
      if [ $? -eq 0 ]
	  then
		echo "`date +"%F %H:%M:%S"`: $1 is UP"
      else
		echo "`date +"%F %H:%M:%S"`: $1 is down"
      fi
     #脚本控制，5秒执行一次
      sleep 5
done

