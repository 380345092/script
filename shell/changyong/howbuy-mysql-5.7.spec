%define debug_package %{nil}

%global mysql_name      mysql
%global mysql_vendor    howbuy
%global mysql_version   5.7.29
%global mysqld_user     mysql
%global mysqld_group    mysql
#%global mysqldatadir    /var/lib/mysql
%global release         1.el7
%global prefix          /usr/local/mysql


##############################################################################
# Main spec file section
##############################################################################

Name:           %{mysql_vendor}-%{mysql_name}
Summary:        MySQL: a very fast and reliable SQL database server
Group:          Applications/Databases
Version:        %{mysql_version}
Release:        %{release}
Distribution:   Red Hat Enterprise Linux
License:        Copyright (c) 2000, 2016, %{mysql_vendor}. All rights reserved. Under %{license_type} license as shown in the Description field.
Source:         %{mysql_name}-%{mysql_version}.tar.gz
Packager:       Howbuy MySQL Release Engineering
Vendor:         %{mysql_vendor}
BuildRequires:  gcc-c++ ncurses-devel perl time zlib-devel cmake libaio-devel numactl-devel openssl-devel zlib-devel
Prefix:         %{prefix}
AutoReqProv:    no
Conflicts:      mysql-server mariadb-server


# Regression tests may take a long time, override the default to skip them 
%{!?runselftest:%global runselftest 1}

# Think about what you use here since the first step is to
# run a rm -rf
BuildRoot:    %{_tmppath}/%{mysql_name}-%{version}-build

# From the manual
%description
The MySQL(TM) software delivers a very fast, multi-threaded, multi-user,
and robust SQL (Structured Query Language) database server. MySQL Server
is intended for mission-critical, heavy-load production systems as well
as for embedding into mass-deployed software. MySQL is a trademark of
%{mysql_vendor}

##############################################################################
%prep
%setup -n %{mysql_name}-%{version}
##############################################################################
%build

prefix=%{prefix}
# # Be strict about variables, bail at earliest opportunity, etc.
# set -eu
# 
# cmake . -DCMAKE_INSTALL_PREFIX=${prefix} \
#         -DSYSCONFDIR=${prefix}/config \
#         -DMYSQL_DATADIR=${prefix}/data \
#         -DMYSQL_UNIX_ADDR=${prefix}/config/mysqld.sock \
#         -DWITH_MYISAM_STORAGE_ENGINE=1 \
#         -DWITH_INNOBASE_STORAGE_ENGINE=1 \
#         -DWITH_MEMORY_STORAGE_ENGINE=1 \
#         -DWITH_PARTITION_STORAGE_ENGINE=1 \
#         -DWITH_ARCHIVE_STORAGE_ENGINE=1 \
#         -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
#         -DWITH_FEDERATED_STORAGE_ENGINE=1 \
#         -DWITH_PERFSCHEMA_STORAGE_ENGINE=1 \
#         -DENABLED_LOCAL_INFILE=1 \
#         -DMYSQL_TCP_PORT=3306 \
#         -DWITH_EXTRA_CHARSETS=all \
#         -DWITH_DEBUG=0 \
#         -DENABLE_DEBUG_SYNC=0 \
#         -DWITH_SSL=system \
#         -DWITH_ZLIB=system \
#         -DWITH_READLINE=1 \
#         -DZLIB_INCLUDE_DIR=/usr \
#         -DWITH_READLINE=1 \
#         -DDEFAULT_CHARSET=utf8 \
#         -DDEFAULT_COLLATION=utf8_general_ci
# make


##############################################################################
%install

RBR=$RPM_BUILD_ROOT
MBD=$RPM_BUILD_DIR/%{mysql_name}-%{version}
mkdir -p $RBR/%{prefix}
cp -ar $MBD/* $RBR/%{prefix}
mv $RBR/%{prefix} $RBR/%{prefix}-%{version}
cd $RBR/%{prefix}-%{version}/../
ln -s %{mysql_name}-%{version} %{mysql_name}
cd -
# 
# # Install all binaries
# cd $MBD
# [ -d $RBR%{_sysconfdir}/init.d ] || mkdir -p $RBR%{_sysconfdir}/init.d
# [ -d $RBR%{_sysconfdir}/profile.d ] || mkdir -p $RBR%{_sysconfdir}/profile.d
# make DESTDIR=$RBR install
# 
#/data/mysql/*
rm -rf ${RBR}/data/mysql
mkdir -p ${RBR}/data/mysql/log
mkdir -p ${RBR}/data/mysql/data
mkdir -p ${RBR}/data/mysql/tmp

#/etc/profile.d/hbmysql.sh
mkdir -p $RBR%{_sysconfdir}/profile.d
touch $RBR%{_sysconfdir}/profile.d/hbmysql.sh
echo "#!/bin/bash" >$RBR%{_sysconfdir}/profile.d/hbmysql.sh

#/etc/init.d/mysql
mkdir -p $RBR%{_sysconfdir}/init.d/
cp $RBR/%{prefix}/support-files/mysql.server $RBR/%{_sysconfdir}/init.d/mysqld
chmod 755 $RBR%{_sysconfdir}/init.d/mysqld

##############################################################################
#  Post processing actions, i.e. when installed
##############################################################################

#%pre
# This is the code running at the beginning of a RPM upgrade action,
# before replacing the old files with the new ones.

%post
# This is the code running at the end of a RPM install or upgrade action,
# after the (new) files have been written.

# Create user. The user may already exist, make sure it has the proper group nevertheless
groupadd -r %{mysqld_group} 2> /dev/null || true
useradd  -g %{mysqld_group} %{mysqld_user} 2> /dev/null || true
usermod -g %{mysqld_group} %{mysqld_user} 2> /dev/null || true
chage -M -1 %{mysqld_user} || true
echo 'mysql' | passwd --stdin %{mysqld_user}
echo "PATH=/usr/local/mysql/bin:\$PATH; export PATH" >>%{_sysconfdir}/profile.d/hbmysql.sh


# #/etc/security/limits.conf
# sed -ri '/^[ \t]*\*[ \t]*soft[ \t]*nproc[ \t]*[0-9]+/d'  %{_sysconfdir}/security/limits.conf
# sed -ri '/^[ \t]*\*[ \t]*soft[ \t]*nofile[ \t]*[0-9]+/d' %{_sysconfdir}/security/limits.conf
# sed -ri '/^[ \t]*\*[ \t]*hard[ \t]*nproc[ \t]*[0-9]+/d'  %{_sysconfdir}/security/limits.conf
# sed -ri '/^[ \t]*\*[ \t]*hard[ \t]*nofile[ \t]*[0-9]+/d' %{_sysconfdir}/security/limits.conf
# cat <<EOF >>%{_sysconfdir}/security/limits.conf
# *	 soft    nproc   	 2047
# *	 hard    nproc   	 16384
# *	 soft    nofile  	 65536
# *	 hard    nofile  	 65536
# EOF

#/etc/my.cnf
cat <<EOF >%{_sysconfdir}/my.cnf
# /etc/my.cnf
# mysql version 5.7
#/data/mysql/data is the directory of data
#/data/mysql/log is the directory of  binlog
#/data/mysql/tmp is the directory of  tmp_file
# enhanced multi-threaded slave  
[mysqld]
######### Need modify according to the environment #########
server-id                       = 10
innodb_buffer_pool_size         = 8G
innodb_buffer_pool_instances    = 8
innodb_log_file_size            = 1G
innodb_log_files_in_group       = 4

basedir                         = /usr/local/mysql
datadir                         = /data/mysql/data
tmpdir                          = /data/mysql/tmp
log_bin                         = /data/mysql/log/bin
log-bin-index                   = /data/mysql/log/bin.index
relay_log                       = /data/mysql/log/relay
pid-file                        = pid
socket                          = /data/mysql/data/mysql.sock

sql_mode                        = STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER
lower_case_table_names          = 1

######### General #########
skip_name_resolve
log_slave_updates
#skip-grant-tables
#skip-networking
#skip-slave-start

user                            = mysql
port                            = 3306
performance_schema              = 1
character_set_server            = utf8mb4     # If the version of the mysql server is 5.1,set default-character-set=utf8.
autocommit                      = 1
max_connections                 = 1000
max_connect_errors              = 1000000
max_allowed_packet              = 1G
innodb_open_files               = 512         # It specifies the maximum number of .ibd files that MySQL can keep open at one time.
table_definition_cache          = 512         # The number of table definitions (from .frm files) that can be stored in the definition cache.If innodb_open_files is set also, the highest setting is used.
table_open_cache                = 2048        # The number of open tables for all threads.
table_open_cache_instances      = 16          # A value of 8 or 16 is recommended on systems that routinely use 16 or more cores.

######### timeout and lock #########
lock_wait_timeout               = 3           # metadata lock.
innodb_lock_wait_timeout        = 5           # innodb row lock.
wait_timeout                    = 1800   
interactive_timeout             = 1800   

######### Binlog #########
sync_binlog                     = 1
binlog_format                   = ROW
binlog_cache_size               = 1M          # default 32768.for large transactions, increase the value.see Binlog_cache_use and Binlog_cache_disk_use status variables.
expire_logs_days                = 15
binlog_rows_query_log_events    = 1           # write informational log events such as row query log events into its binary log

######### InnoDB #########
default_storage_engine          = InnoDB
default_tmp_storage_engine      = InnoDB
transaction_isolation           = READ-COMMITTED  #REPEATABLE-READ
innodb_flush_method             = O_DIRECT
innodb_file_format              = Barracuda       # is deprecated and will be removed
innodb_file_format_max          = Barracuda       # is deprecated and will be removed
#innodb_data_file_path           = ibdata1:12M:autoextend   # default ibdata1:12M:autoextend.
innodb_file_per_table           = 1
innodb_purge_threads            = 4           # if the number of the core is more,the max value is  16.
innodb_page_cleaners            = 8           # the max value is  64,if the number of the core is more,can set to the same value as innodb_buffer_pool_instances.
innodb_page_size                = 16K         # InnoDB page size (default 16KB).
innodb_log_buffer_size          = 16M             
innodb_sort_buffer_size         = 64M             
#innodb_support_xa             = 1            # After 5.7.10,will can not  Disabling innodb_support_xa.two-phase commit in XA transactions is always enabled.
innodb_flush_log_at_trx_commit  = 1           # default 1.
innodb_strict_mode              = 1               
innodb_print_all_deadlocks      = 1               
innodb_flush_neighbors          = 0               
innodb_online_alter_log_max_size= 1G          # Specifies an upper limit on the size of the temporary log files used during online DDL operations for InnoDB tables.
innodb_buffer_pool_dump_at_shutdown      = 1
innodb_buffer_pool_load_at_startup       = 1

######### Fusion-io #########
innodb_io_capacity              = 500         # if is ssd,can be set to The count of iops. a disk may be  1000.
innodb_io_capacity_max          = 1000        # When configuring innodb_io_capacity_max, twice the innodb_io_capacity is often a good starting point.
innodb_write_io_threads         = 8           # simple can be set to The number of disk.
innodb_read_io_threads          = 8           # simple can be set to The number of disk. 
                                                  
######### Global #########                        
query_cache_type                = 0           # default 0.no use QC.
query_cache_size                = 0           # no use. 

######### Session #########
tmp_table_size                  = 64M
sort_buffer_size                = 32M
join_buffer_size                = 128M
read_buffer_size                = 16M
read_rnd_buffer_size            = 32M

######### Error-log #########
log_error                       = error.log
log_error_verbosity             = 3           # default 3(note warning error),2(warning error)

######### Slow-log #########
long_query_time                 = 1
slow_query_log                  = 1
log_slow_admin_statements       = 1
log_slow_slave_statements       = 1
min_examined_row_limit          = 10001       # performance_schema_digests_size default is 10000.In order to MEM use this table to query data not record to slow.log.
slow_query_log_file             = slow.log
log_queries_not_using_indexes            = 1  # Whether queries that do not use indexes are logged to the slow query log.
log_throttle_queries_not_using_indexes   = 10 # limits the number of such queries per minute that can be written to the slow query log. A value of 0 (the default) means "no limit".


######### Replacation #########
log_timestamps                  = system
slave_skip_errors               = ddl_exist_errors
slave_pending_jobs_size_max     = 1G          # The value must not be less than the master's value for max_allowed_packet which prevent a slave worker queue may become full.
#super_read_only                = NO          # on the slave,if set it to Yes,there is a problem to cause OOM.default OFF.

######### Slave #########
master_info_repository          = TABLE
relay_log_info_repository       = TABLE
relay_log_recovery              = 1
slave-parallel-type             = LOGICAL_CLOCK
slave-parallel-workers          = 8

######### Semi sync replication #########
#plugin_dir                     = /usr/local/mysql/lib/plugin/
plugin_load                    = "rpl_semi_sync_master=semisync_master.so;rpl_semi_sync_slave=semisync_slave.so"
rpl_semi_sync_master_enabled   = 1
rpl_semi_sync_slave_enabled    = 1
rpl_semi_sync_master_timeout   = 3000

[mysqld-5.7]
innodb_purge_rseg_truncate_frequency = 128
innodb_buffer_pool_dump_pct     = 40
innodb_undo_log_truncate        = on
innodb_max_undo_log_size        = 2G
innodb_undo_logs                = 128
innodb_undo_tablespaces         = 3
slave_transaction_retries       = 128
show_compatibility_56           = on          # will be removed.
slave_preserve_commit_order     = 1
innodb_lru_scan_depth           = 512
explicit_defaults_for_timestamp = 1

######## PS ########
performance_schema_instrument                              = 'transaction=ON'                         # transaction
performance_schema_instrument                              = 'wait/lock/metadata/sql/mdl=ON'          # metadata
performance_schema_instrument                              = 'memory/%=COUNTED'                       # memory 
performance_schema_consumer_events_statements_history_long = ON
performance_schema_consumer_events_transactions_current    = ON
performance_schema_consumer_events_transactions_history    = ON
performance_schema_max_sql_text_length                     = 2048                                     # for MEM QUAN
max_digest_length                                          = 2048                                     # for MEM QUAN


[mysql]
socket                  = /data/mysql/data/mysql.sock
default-character-set   = utf8
max_allowed_packet      = 1G
prompt                  = [\\u@\\h][\\d][\\r:\\m:\\s]>\\_
#prompt                  = [\\u@\\h@\\p][\\d][\\r:\\m:\\s]>\\_
no-auto-rehash
#safe-updates                                 Permit only those UPDATE and DELETE statements that specify which rows to modify by using key values.
EOF

#chown mysql:mysql /data/mysql /etc/my.cnf
chown -R %{mysqld_user}:%{mysqld_group} $RPM_INSTALL_PREFIX $RPM_INSTALL_PREFIX-%{version}
chown -R %{mysqld_user}:%{mysqld_group} %{_sysconfdir}/my.cnf /data/mysql %{_sysconfdir}/init.d/mysqld
# cd $RPM_INSTALL_PREFIX && ./mysql_install_db --user=%{mysqld_user}
# chown -R %{mysqld_user}:%{mysqld_group} %{_sysconfdir}/my.cnf $RPM_INSTALL_PREFIX
$RPM_INSTALL_PREFIX/bin/mysqld --initialize --user=mysql --datadir=/data/mysql/data

/sbin/chkconfig --add mysqld
export "PATH="$RPM_INSTALL_PREFIX"/bin:$PATH" 

su mysql -c "/etc/init.d/mysqld start"
pass=`grep "A temporary password is generated for root@localhost" /data/mysql/data/error.log| sed 's/^.*root@localhost: //g'`
mysqladmin -uroot -p${pass} password mysql -S /data/mysql/data/mysql.sock
##############################################################################
#  Files section
##############################################################################

%files
/data/mysql
/usr/local/*
/etc/init.d/mysqld
/etc/profile.d/hbmysql.sh
