#!/bin/bash

#variables
nginx_install_doc=/usr/local/nginx
nginxd=$nginx_install_doc/sbin/nginx
pid_file=$nginx_install_doc/logs/nginx.pid
proc=nginx
# Source function library.
#调用系统的函数库  . 是source的意思
if [ -f /etc/init.d/functions ]
   then
	. /etc/init.d/functions
else
   echo "not found file /etc/init.d/functions"
   exit
fi

#查看nginx.pid号，并赋值
#根据pid号，查看nginx启动状态，并且过滤掉本身grep的那一项，剩下的就是和nginx有关的启动项，只要大于等于1，就代表ng启动成功
if [ -f $pid_file ];then
	nginx_process_id=`cat $pid_file`
	nginx_process_num=`ps -ef | grep $nginx_process_id | grep -v "grep" | wc -l`
else
	nginx_process_num=0
fi

#function
start () {
#如果nginx没有启动直接启动。否则报错，已经启动
if [ -f $pid_file ] && [ $nginx_process_num -ge 1 ]
   then
	echo "nginx running..."
else
   if [ -f $pid_file ] && [ $nginx_process_num -lt 1 ]
   then
	rm -f $pid_file
#daemon 系统自带函数启动各种程序
#或者用action的方式启动也可以，两者选一
        #echo "nginx start `daemon $nginxd`" 
	      action "nginx start" $nginxd
   fi
   #echo "nginx start `daemon $nginxd`"
        action "nginx start" $nginxd
fi

}

stop () {
if [ -f $pid_file ] && [ $nginx_process_num -ge 1 ];then
   action "nginx stop" killall -s QUIT $proc
   rm -f $pid_file
else
#系统报错信息丢掉
    action "nginx stop" killall -s QUIT $proc 2>/dev/null
   #echo "nginx stop `killall -s QUIT nginx 2>/dev/null`"
   rm -f $pid_file
fi
}

restart () {
   stop
   sleep 1
   start
}

reload () {
if [ -f $pid_file ] && [ $nginx_process_num -ge 1 ];then
	action "nginx reload" killall -s HUP $proc"
else
	action "nginx reload" killall -s HUP $proc"
fi
}

status () {
if [ -f $pid_file ] && [ $nginx_process_num -ge 1 ];then
	echo "nginx running..."
else
	echo "nginx stop"
fi
}

#callable
case $1 in
start) start
;;
stop) stop
;;
restart) restart
;;
reload) reload
;;
status) status
;;
*) echo "USAGE: $0 start|stop|restart|reload|status"
;;
esac
