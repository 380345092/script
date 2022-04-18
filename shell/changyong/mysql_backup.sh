#!/bin/bash

#1，确定binlog的位置及备份时间间隔，每天
	#当前要备份的binlog是谁
	#刷新binlog日志，生成新的binlog用以存储备份节点后的数据
#2，打包binlog日志，以年-月-日_binlog.tar.gz格式
#3，生成校验码   md5sum
#4，将校验码和压缩包存到文件夹   文件夹命名 年-月-日 再次打包
#5，使用scp拷贝到备份服务器
#6，备份机器解压收到的目录压缩包，通过校验码，校验binlog压缩包是否完整
	#完整，完成备份  ---------发邮件给管理员，明确备份成功
	#不完整，报错	----------发邮件给管理员，要求手动备份


db_user='root'
db_password=''
backup_server='192.168.223.156'
backup_dir='/data/backup'

backup () {
#获得信息，获取当前binlog
binlog_dir='/var/lib/mysql'
current_binlog=`mysql -u $db_user -e "show master status" | egrep "binlog.[[:digit:]]*"|awk '{print $1}'`

#准备备份
#1 刷新binlog,用flush logs命令，刷新完成后，就会生成一个新的binlog，旧的binlog里面不再写日志，这样就可以备份旧的日志，新日志不会写入
mysql -u $db_user -e "flush logs"
#2 打包要备份binlog
tar zcf `data +%F`.binlog.tar.gz $binlog_dir/$current_binlog
#3 用mds5sum对生成的压缩包进行校验，并且输出到txt文件
md5sum `data +%F`.binlog.tar.gz > `data +%F`_md5sum.txt
#4 存入文件夹
[ ! -d `data +%F` ] && mkdir `data +%F` 
mv `data +%F`.binlog.tar.gz `data +%F`
mv `data +%F`_md5sum.txt `data +%F`
#打包目录
tar zcf `data +%F`.tar.gz `data +%F`

#5，拷贝
#要求提前做证书信任
scp `data +%F`.tar.gz root@$backup_server:$backup_dir

if [ $? -ne 0 ];then
   echo "ERROR: scp `data +%F`.tar.gz fail"
   exit 1
fi

#6，校验
#需要解压缩到指定目录，要不然会默认解压到当前目录，导致后面的内容无法执行
ssh root@$backup_server "tar xf $backup_dir/`date +%F`.tar.gz -C $backup_dir"
ssh root@$backup_server "cd $backup_dir/`date +%F`;md5sum -c `date +%F`_md5sum.txt "
#md5sum需要先cd到文件所在目录，才可以执行md5sum，否则会找不到文件，且要在一条命令里面执行

if [ $? -eq 0 ];then
   echo "success"
   ssh root@$backup_server "rm -rf $backup_dir/`date +%F`"
else
   echo "fail"
fi

}

backup
