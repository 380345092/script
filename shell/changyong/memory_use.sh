#!/bin/bash
#使用顺序free>cache>buffer>swap
memory_use() {
memory_used=`head -2 /proc/meminfo | awk 'NR==1{t=$2}NR==2{f=$2;print(t-f)*100/t"%"}'`
memory_cache=`head -5 /proc/meminfo | awk 'NR==1{t=$2}NR==5{c=$2;print c*100/t"%"}'`
memory_buffer=`head -4 /proc/meminfo | awk 'NR==1{t=$2}NR==4{b=$2;print b*100/t"%"}'`

#echo "memory_used: $memory_used"
#echo "memory_cached: $memory_cache"
#echo "memory_bufferd: $memory_buffer"

echo -e "memory_used:$memory_used\tbuffer:$memory_buffer\tcached:$memory_cache"

}
memory_use
