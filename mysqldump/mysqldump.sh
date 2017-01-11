#! /bin/bash

#2016-07-27--mysqldump.sh-v1.0 自动获取mysql安装路径
#2016-07-29--mysqldump.sh-v1.1  修改my.cnf文件
#2016-08-02--mysqldump.sh-v1.2  排除自带的两个库

STIME=`date +%F`
BACKUP_PATH='/backup/backup_file'
Mycnf='/etc/my.cnf'
Mycnf1='/etc/my1.cnf'
cp $Mycnf $Mycnf1
echo -e "[mysql]\nuser=root\npassword=123456\n\n[mysqldump]\nuser=root\npassword=123456">>$Mycnf

#获取mysql安装路径
which mysql>$BACKUP_PATH/temp.txt
sed -n '1p' $BACKUP_PATH/temp.txt>$BACKUP_PATH/temp1.txt
sed 's/mysql//g' $BACKUP_PATH/temp1.txt>$BACKUP_PATH/temp.txt
MYSQL_BIN_PATH=$(cat $BACKUP_PATH/temp.txt)
echo "show databases;">$BACKUP_PATH/show.txt
cd $MYSQL_BIN_PATH
date +"%Y-%m-%d %H:%M:%S">>$BACKUP_PATH/display.txt
mysql<$BACKUP_PATH/show.txt>$BACKUP_PATH/databases.txt 2>>$BACKUP_PATH/display.txt

sed -i '1d' $BACKUP_PATH/databases.txt
sed ':a ; N;s/\n/ / ; t a ; ' $BACKUP_PATH/databases.txt>$BACKUP_PATH/databases1.txt

sed -e 's/performance_schema //' $BACKUP_PATH/databases1.txt>$BACKUP_PATH/databases.txt
sed -e 's/information_schema //' $BACKUP_PATH/databases.txt>$BACKUP_PATH/databases1.txt

databases=($(cat $BACKUP_PATH/databases1.txt))
rm -f $BACKUP_PATH/show.txt
rm -f $BACKUP_PATH/databases.txt
rm -f $BACKUP_PATH/databases1.txt
rm -f $BACKUP_PATH/temp.txt
rm -f $BACKUP_PATH/temp1.txt
for dbname in ${databases[*]}
do
echo `date +%Y-%m-%d_%k-%M-%S`" start backup database "$dbname >> $BACKUP_PATH/backup.log
${MYSQL_BIN_PATH}mysqldump --opt --compress $dbname > $BACKUP_PATH/backup-$dbname-$STIME.sql 2>>$BACKUP_PATH/display.txt
  if [ "$?" == "0" ]
  then
  echo `date +%Y-%m-%d_%k-%M-%S`" end backup database "$dbname >> $BACKUP_PATH/backup.log
  else
  echo `date +%Y-%m-%d_%k-%M-%S`" error backup database "$dbname >> $BACKUP_PATH/backup.log
  fi
done
rm -f $Mycnf
cp $Mycnf1 $Mycnf
rm -f $Mycnf1
echo "finish"
