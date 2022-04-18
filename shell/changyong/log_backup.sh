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


backup_server='192.168.223.156'
backup_dir='/data/backup'

backup () {
#获得信息，获取当前binlog
log_dir='/var/log'
current_log=`ls -l /var/log/ | egrep "messages-[0-9]*"| tail -1 | awk '{print $NF}'`

#准备备份
#2 打包要备份binlog
tar zcf `date +%F`.log.tar.gz $log_dir/$current_log &>/dev/null 2>&1
#3 用mds5sum对生成的压缩包进行校验，并且输出到txt文件
#如果是备份普通文件的话，可以不需要校验这一步，之后的语句需要稍做修改
md5sum `date +%F`.log.tar.gz > `date +%F`_md5sum.txt
#4 存入文件夹
[ ! -d `date +%F` ] && mkdir `date +%F` 
mv `date +%F`.log.tar.gz `date +%F`
mv `date +%F`_md5sum.txt `date +%F`
#打包目录
tar zcf `date +%F`.tar.gz `date +%F` &>/dev/null 2>&1

#5，拷贝
#要求提前做证书信任
scp `date +%F`.tar.gz root@$backup_server:$backup_dir &>/dev/null 2>&1

if [ $? -ne 0 ];then
   echo "ERROR: scp `date +%F`.tar.gz fail"
   exit 1
fi

#6，校验
#需要解压缩到指定目录，要不然会默认解压到当前目录，导致后面的内容无法执行
ssh root@$backup_server "tar xf $backup_dir/`date +%F`.tar.gz -C $backup_dir &>/dev/null 2>&1"
ssh root@$backup_server "cd $backup_dir/`date +%F`;md5sum -c `date +%F`_md5sum.txt &>/dev/null 2>&1"
#md5sum需要先cd到文件所在目录，才可以执行md5sum，否则会找不到文件，且要在一条命令里面执行

#可以把成功或者失败的结果，或者执行过程中的输出结果导入某个日志，方便排错
if [ $? -eq 0 ];then
   echo "success" 
   ssh root@$backup_server "rm -rf $backup_dir/`date +%F`"
   #删除本机遗留tar包和解压缩后的文件，如果需要删除
   rm -rf `date +%F`*
else
   echo "fail"
fi

}

backup
