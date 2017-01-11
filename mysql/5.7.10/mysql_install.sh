#!/bin/bash

#安装mysql 并修改数据库
#安装日志路径/home/log
#mysql5.7.10

MYSQL_server="mysql-community-server-5.7.10-1.el6.x86_64.rpm"
MYSQL_client="mysql-community-client-5.7.10-1.el6.x86_64.rpm"
MYSQL_libs="mysql-community-libs-5.7.10-1.el6.x86_64.rpm"
MYSQL_common="mysql-community-common-5.7.10-1.el6.x86_64.rpm"

MYSQL_path="/usr"
Logfile="/home/log"
passwd_root="L1Rf1wEj"
passwd_tosc="w8Jr3RGy"
Temp="/home/tosc/temp"

check()
{
  if [ $? -ne 0 ]
  then
    echo "[ERROR] $0 install ERROR"
    exit 1
  else 
    echo "[INFO] install successfully"
  fi
}

checkFile()
{
  if [ ! -f $1 ]
  then
    echo "[ERROR] $1 is not exist,please check the file!"
    exit 1
  else
    echo "[INFO] Try to install $1"
  fi  
}


#安装mysql
mkdir -p $Logfile
find / -name "mysql_.zip"  -type f -exec cp {} "$MYSQL_path" \; &>$Logfile/mysql_.log
cd $MYSQL_path
unzip mysql_.zip -d mysql_ &>>$Logfile/mysql_.log
mv $MYSQL_path/mysql_/*.rpm $MYSQL_path

mkdir -p /DATA/{mysql,log/mysql/3306/binlog}
chown -R mysql:mysql /DATA/mysql /DATA/log

for i in `rpm -qa|grep -i mysql`
do
rpm -ev $i --nodeps
done

rm -rf /etc/my.cnf
yum update -y &>>$Logfile/yum_.log
yum upgrade -y &>>$Logfile/yum_.log
yum install numactl -y &>>$Logfile/yum_.log
####################################################
checkFile $MYSQL_common
rpm -vih $MYSQL_common &>$Logfile/MYSQL_common.log
check

checkFile $MYSQL_libs
rpm -vih $MYSQL_libs &>$Logfile/MYSQL_libs.log
check

checkFile $MYSQL_client
rpm -vih $MYSQL_client &>$Logfile/MYSQL_client.log
check

checkFile $MYSQL_server
rpm -vih $MYSQL_server &>$Logfile/MYSQL_server.log
check

############################################3
echo -e "[client]
default-character-set=utf8
port=3306
socket=/DATA/mysql/mysql.sock

[mysqld]
character-set-server=utf8
datadir=/DATA/mysql
socket=/DATA/mysql/mysql.sock
user=mysql
port=3306
symbolic-links=0
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER

server-id = 1
log-bin=/DATA/log/mysql/3306/binlog/binlog
binlog_cache_size=4M
binlog_format=ROW
max_binlog_cache_size=8M
max_binlog_size=1G
expire_logs_days=30
#validate_password_length=6
#validate_password_policy='LOW'

log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid">/etc/my.cnf
chown mysql.mysql /etc/my.cnf
rm -rf /DATA/mysql/*
#updata root password
service mysqld start
sed -i "s/#//g" /etc/my.cnf
service mysqld restart

mkdir -p $Temp
p=`grep 'temporary password' /var/log/mysqld.log`
j=`echo ${p##*root@localhost: }`
mysqladmin -uroot -p"$j" password "$passwd_root" 2>/dev/null

ln -s /DATA/mysql/mysql.sock /var/lib/mysql/mysql.sock
chown -R mysql:mysql /var/lib/mysql/mysql.sock
service mysqld stop

echo "[INFO] mysql install successfully"
echo "[INFO] root password:$passwd_root"

rm -rf $MYSQL_path/$MYSQL_server $MYSQL_path/$MYSQL_client
