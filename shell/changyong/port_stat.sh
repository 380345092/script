#!/bin/bash

port_status () {
temp_file=`mktemp port_status.XXX` 
[ ! -x /usr/bin/telnet ] && echo "telnet not found command " && exit 1

#测试端口 $1 IP  $2 port，把quit用eof输出到前面的命令中，执行退出
(telnet $1 $2 <<EOF
quit
EOF
) &>$temp_file

#分析文件中的内容
if egrep "\^]" $temp_file &>/dev/null;then
   echo "$1 $2 is open"
else
   echo "$1 $2 is close"
fi

rm -rf $temp_file
}
#函数需要带参数，要不然无法取到
port_status $1 $2
