#!/bin/bash   
#ogg_ssh_status.sh-v1.1
#
#$#脚本参数
if [ "$#" -ne 2 ] ; then
    echo "USAGE: ogg_ssh_status.sh hostlist ogg_status.sh"
    exit -1
fi

file_name=$1
cmd_str=$2
cwd=$(pwd)
cd $cwd
hostlist_file="$cwd/$file_name"
cmd_file="$cwd/$cmd_str"


if [ ! -e $hostlist_file ] ; then
    echo 'hostlist file not exist';
    exit 0
fi

if [ ! -e $cmd_file ] ; then
    echo 'cmd_file file not exist';
    exit 0
fi

var=`rpm -qa|grep sshpass`
if [ ! -n "$var" ]; then
  echo "you should install sshpass first"
  read -p "Install sshpass? yes--y    no--exit: "  tem
  if [ "$tem" == 'y' -o "$tem" == 'Y' ]; then
    rpm -vih sshpass-1.05-7.1.x86_64.rpm
  else
    exit 0
  fi
fi


num=`sed -n '$=' $hostlist_file`
for i in `seq $num`;do
    #ip  user address
    ip=`awk ''NR==$i' {print $1}' $hostlist_file`
    user=`awk ''NR==$i' {print $2}' $hostlist_file`
    pass=`awk ''NR==$i' {print $3}' $hostlist_file`
    address=`awk ''NR==$i' {print $4}' $hostlist_file`
    sed -i "2i OGG_HOME=$address" $cmd_file
    echo "----------"$ip"----------"
    sshpass -p "$pass" ssh -t $user@$ip -o StrictHostKeyChecking=no <$cmd_file 2>/dev/null    
   # sshpass -p "$pass" ssh -t $user@$ip<$cmd_file

    if [ $? -eq 0 ] ; then
        echo "$cmd_str Executed Successfully!"
        echo ""
    else
        echo "error: " $?
    fi

    sed -i '2d' $cmd_file
done
