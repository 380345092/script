#!/bin/bash
#统计系统中前10的使用内存最多的进程

memory () {

   temp_file=`mktemp memory.XXX`
   top -b -n 1 > $temp_file
#按进程统计内存使用大小
   tail -n +8 $temp_file | awk '{array[$NF]+=$6}END{for (i in array) print array[i],i}' | sort -k 1 -n -r | head -10

rm -f $temp_file
}

#统计系统中前10的使用cpu最多的进程
cpu () {
#收集任务管理器进程信息
   temp_file=`mktemp cpu.XXX`
   top -b -n 1 > $temp_file
#按进程统计内存使用大小
   tail -n +8 $temp_file | awk '{array[$NF]+=$9}END{for (i in array) print array[i],i}' | sort -k 1 -n -r | head -10

rm -rf $temp_file
}

case $1 in
memory) memory
;;
cpu) cpu
;;

esac
