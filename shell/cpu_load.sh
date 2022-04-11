#!/bin/bash
#这里有个问题，如果用第一种方式取值的话，uptime的值如果是1天内或者多天，他输出的结果是不一样的，当中会多空格出来，导致后面的取值不准,所以后面两种方式更准确一点

#cpu_load=(`uptime|tr -s " " | cut -d " " -f 9-11|tr "," " "`)
#cpu_load=(`uptime | awk '{print $(NF-2),$(NF-1),$(NF)}'|tr "," " "`)
cpu_load=(`cat /proc/loadavg | awk '{print $1,$2,$3}'`)
echo "CPU 1 min 平均负载为：${cpu_load[0]}"
echo "CPU 5 min 平均负载为：${cpu_load[1]}"
echo "CPU 15 min 平均负载为：${cpu_load[2]}"
