#!/bin/bash
#安装用户 root
#安装前准备 依赖包 源码包获得
#安装
#启动 测试

echo "This is a nginx install script"
#这里要先赋值ver,要不然后面nginx_pkg取不到$ver的值，导致下载失败，因为是从上往下执行的，如果把这两段放在最后callable一起的话，那么一开始nginx_pkg无法取值ver
read -p "Enter nginx_version:" ver


#variables
#nginx_pkg="nginx-1.21.6.tar.gz"
#nginx版本号这里可以引用$version,这样执行脚本的时候直接带上任意ng版本号，就可以安装任意版本的ng，不需要修改脚本
nginx_pkg="nginx-$ver.tar.gz"
nginx_source_doc=`echo $nginx_pkg | cut -d "." -f1-3`
nginx_install_doc="/usr/local/nginx"
nginx_user="www"
nginx_group="www"

#function
check () {
   #检测当前用户，要求为root
   if [ "$USER" != 'root' ];then
	echo "need to be root so that"
	exit 1
   fi

   #检查wget命令
   if [ ! -x /usr/bin/wget ];then
	yum install -y wget >/dev/null 2>&1
   fi
   #[ ! -x /usr/bin/wget ] && echo "not found command /usr/bin/wget" && exit 1
   #两种方式都可以&&等于then的意思，||等于后面的else
   echo "check successe"
}

install_pre () {
   #1.安装依赖
   if ! (yum -y install gcc-* pcre-devel zlib-devel elinks >/dev/null 2>&1);then
	echo "ERROR: yum install error"
	exit 1
   fi
   
   #2.下载源码包
   if wget https://nginx.org/download/$nginx_pkg >/dev/null 2>&1;then
	tar -zxvf $nginx_pkg >/dev/null 2>&1
	if [ ! -d $nginx_source_doc ];then
	   echo "ERROR:not found $nginx_source_doc"
	   exit 1
	fi
   else
	echo "ERROR:Download file $nginx_pkg fail"
	exit 1
   fi
   echo "install_pre successe"
}

install () {
   #1.创建管理用户
   useradd -r -s /sbin/nologin $nginx_user
   #2.安装nginx
   cd $nginx_source_doc
   echo "nginx configure...."	
   if ./configure --prefix=$nginx_install_doc --user=$nginx_user --group=$nginx_group >/dev/null 2>&1;then
	echo "nginx make...."
	if make >/dev/null 2>&1;then
           echo "nginx make install..."
	   if make install >/dev/null 2>&1;then
		echo "nginx install success"
	   else 
	        echo "ERROR:nginx make install fail";exit 1
           fi
	else
	   echo "ERROR:nginx make fail";exit 1
        fi
   else
	echo "echo "ERROR:nginx configure fail";exit 1"
   fi

}

nginx_test () {
   if $nginx_install_doc/sbin/nginx;then
	echo "nginx start SUCCESS!"
	elinks http://localhost -dump
   else
	echo "nginx stop FAIL"
   fi
}

#callable
read -p "Press Y to install,Press C to cancel:" ch

if [ $ch == 'Y' ];then
   check;install_pre;install;nginx_test
elif [ $ch == 'C' ];then
   exit 1
fi

