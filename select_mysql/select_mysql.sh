#!/bin/bash
#2017-04-20 select_mysql.sh
#
SZP='cdr'
Path='/mysql56'
user='root'
password='123456'
#生成sql语句
echo "select concat(concat(concat('select ',\"'\",table_name,\"'\",','),\
'count(*) from '),concat(concat(table_schema,'.'),concat(table_name,';'))) \
from information_schema.tables where engine='InnoDB' \
and table_schema='$SZP' into outfile '$Path/check.$SZP.sql';">$Path/tem.log
#查询
mysql -u"$user" -p"$password" -S /tmp/mysql3306.sock<$Path/tem.log
mysql -u"$user" -p"$password" -S /tmp/mysql3306.sock<$Path/check.$SZP.sql >$Path/check.$SZP.txt
#处理结果
sed -n '1,$n;p' $Path/check.$SZP.txt>$Path/check.txt
awk '{printf ("%40s   %-4s \n",$1,$2)}' $Path/check.txt>$Path/check.$SZP.txt
rm -rf $Path/check.txt $Path/tem.log