#! /bin/bash

#$OGG_status/copystatus.log文件是所有使用脚本后的日志文件
#2016-07-18--ogg_status.sh-v1.0 读取ogg状态脚本
#2016-07-19--ogg_status.sh-v1.1 增加手动输入路径
#2016-09-07--ogg_status.sh-v1.2 修改路径回车bug

export PATH=$PATH:/home/oracle/ogg/
OGG_HOME="/u01/app/ogg"

read -p "Please enter the installation path: "  add
if [ ! -n "$add" ]; then
    echo "No such directory:$add"    
    echo "The default installation directory:$OGG_HOME"  
elif [ -d $add ];then
    OGG_HOME=$add
else
    echo "No such directory:$add"    
    echo "The default installation directory:$OGG_HOME" 
fi
OGG_status="$OGG_HOME/status"
mkdir -p $OGG_status
echo "info all">$OGG_status/info.txt

#提取进程名
cd $OGG_HOME
./ggsci<$OGG_status/info.txt>$OGG_status/status1.txt
sed -n '/Status/,$p' $OGG_status/status1.txt>$OGG_status/status12.txt
sed  -i '/^$/d' $OGG_status/status12.txt
sed -i '1,2d' $OGG_status/status12.txt
sed -i '$d' $OGG_status/status12.txt
awk '{print $2,$3"\n"}' $OGG_status/status12.txt >$OGG_status/status13.txt
sed  -i '/^$/d' $OGG_status/status13.txt
num=`sed -n '$=' $OGG_status/status13.txt`
date +"%Y-%m-%d %H:%M:%S">>$OGG_status/copystatus.log

if [ $num -eq 0 ];then
    echo "no group"
else
    for i in `seq $num`;do
        awk ''NR==$i' {print $2}' $OGG_status/status13.txt>$OGG_status/temp.txt 
        j=`cat $OGG_status/temp.txt | sed 's/^[[:space:]]*//'` 
        echo "info $j">$OGG_status/info.txt 
        ./ggsci<$OGG_status/info.txt>$OGG_status/status2.txt  
        grep -A 5 'Checkpoint Lag' $OGG_status/status2.txt>$OGG_status/status21.txt
        sed -n '3,3p' $OGG_status/status21.txt>$OGG_status/temp.txt  
        awk '{print $1,$2"\n"}' $OGG_status/temp.txt >$OGG_status/status14.txt
        cat $OGG_status/status14.txt | sed -e '/^$/d'>$OGG_status/temp.txt
        cat $OGG_status/temp.txt|cut -c 1-19 >$OGG_status/status14.txt
#
        awk ''NR==$i' {print $1,$2}' $OGG_status/status13.txt>$OGG_status/tem.txt 
        cat $OGG_status/status14.txt>>$OGG_status/tem.txt
        sed ':a ; N;s/\n/ / ; t a ; ' $OGG_status/tem.txt>$OGG_status/status.txt
#
        cat $OGG_status/status.txt>>$OGG_status/wancheng.txt
    done
fi
#输出
echo " "
echo "Status  Name  Time    "
cat $OGG_status/wancheng.txt
echo " "

cat $OGG_status/wancheng.txt>>$OGG_status/copystatus.log
echo "">>$OGG_status/copystatus.log
#使用shopt命令
cd $OGG_status
shopt -s extglob
rm -rf !(copystatus.log)
#关闭shopt命令
shopt -u extglob