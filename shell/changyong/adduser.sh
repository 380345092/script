#!/bin/bash
#创建user01-user20，随机6位数密码a-zA-Z0-0

#1，创建user01-user02
#2，生成20组随机密码
#3，设置密码
#4，输出清单

pw_txt=`mktemp pw.XXX`
adduser() {
#1，创建账户
for i in `seq -s ' ' -w 1 20`
   do
	useradd -s /sbin/nologin user$i
done 

#2，生成随机6位密码
#egrep "^$"  ^$中的内容为匹配查找
cat /dev/urandom | strings -6 | egrep "^[a-zA-Z0-9]{6}$"| head -20 > $pw_txt

#3,设置密码
for i in `seq -s ' ' -w 1 20`;do
#每次列出新的一行的最后一行
   pw=`head -n $i $pw_txt| tail -1`
#把pw直接输入给用户
   echo $pw | passwd --stdin user$i  &>/dev/null 2>&1
   echo -e "user$i\t\t$pw" >> user_add_result.txt
done

#4，输出
clear
echo "用户创建成功，密码文件是：user_add_result.txt"
cat user_add_result.txt
 
rm -rf $pw_txt
}

adduser
