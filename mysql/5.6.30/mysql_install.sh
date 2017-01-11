#! /bin/bash

#RedHat6.3系统rpm方式安装MySQL5.6.30,并修改随机默认密码，改为$MYSQL_password
#2016-04-26--mysql_install.sh-v1.0
#2016-09-07--mysql_install.sh-v1.1

MYSQL_server="MySQL-server-5.6.30-1.el6.x86_64.rpm"
MYSQL_client="MySQL-client-5.6.30-1.el6.x86_64.rpm"
MYSQL_path="/usr"
MYSQL_password=123456

checkFile()
{
  if [ ! -f $1 ]
  then
    echo "[ERROR] $1 is not exist,please check the file!"
    exit 1
  else
    echo  "[INFO] Try to install $1"
  fi  
}

cd $MYSQL_path
find / -name "$MYSQL_server" -type f -exec mv {} "$MYSQL_path" \;
find / -name "$MYSQL_client" -type f -exec mv {} "$MYSQL_path" \;
#echo `rpm -qa|grep -i mysql`
for i in `rpm -qa|grep -i mysql`
do
rpm -ev $i --nodeps
done

yum -y install numactl
checkFile $MYSQL_server
rpm -vih $MYSQL_server
checkFile $MYSQL_client
rpm -vih $MYSQL_client

#启动数据库
/etc/init.d/mysql start
cat /root/.mysql_secret>/root/secret.txt
sed -i 's/.*(local time)://p' /root/secret.txt
sed -i '2,$d' /root/secret.txt
j=`cat /root/secret.txt | sed 's/^[[:space:]]*//'`
rm -rf /root/secret.txt 

mysqladmin -uroot -p"$j" password "$MYSQL_password"
mysql -uroot -p"$MYSQL_password"