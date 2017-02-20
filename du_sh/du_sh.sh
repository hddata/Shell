#! /bin/bash
#
#du_sh.sh-v1.0
#20170220

if [ "$#" -ne 1 ] ; then
    echo 'USAGE: "./$0 hostlist"'
    exit -1
fi

file_name=$1
cwd=$(pwd)
cd $cwd
list_file="$cwd/$file_name"

if [ ! -e $list_file ] ; then
    echo 'list file not exist';
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


num=`sed -n '$=' $list_file`
rm -rf $cwd/du__sh.log
for i in `seq $num`;do
    #ip  user address
    ip=`awk ''NR==$i' {print $1}' $list_file`
    user=`awk ''NR==$i' {print $2}' $list_file`
    pass=`awk ''NR==$i' {print $3}' $list_file`
    address=`awk ''NR==$i' {print $4}' $list_file`

    tem=`sshpass -p "$pass" ssh -t $user@$ip -o StrictHostKeyChecking=no "cd $address;du -sh"  2>/dev/null`
    if [ $? -eq 0 ] ; then
    	echo "----------$ip----------"
        echo "Executed Successfully!"
        temp=${tem%.*}
        echo $ip    $address     $temp>>$cwd/du__sh.log
    else
    	echo "----------$ip----------"
        echo "error: " $?
        temp=${tem%.*}
        echo $ip    $address     "Error">>$cwd/du__sh.log
    fi
done