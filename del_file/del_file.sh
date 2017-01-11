#! /bin/bash

#定期删除指定路径下n天前的文件
#2016-12-16 del_file.sh-v1.0


add="123"
add1="456"
while [  "$add" != "$add1" ]; do
	read -p "Please enter the directory path: "  add
	read -p "Please enter the directory path again: "  add1
done

if [ ! -n "$add" ]; then
    echo "[ERROR] No such directory:$add"
    echo "[INFO] Exit"
    exit 1   
elif [ -d $add ];then
    echo "[INFO] Directory path: $add"
else
    echo "[ERROR] No such directory:$add"
    echo "[INFO] Exit"
    exit 1
fi

while [ 1 ] ; do
    read -p "Please enter time number (1=30 days 2=60 days,,,,): "  num
    expr $num + 0 1>/dev/null 2>&1
    res=$?
    if [ "$num" = "" ] || [ "$res" != "0" ]; then
        echo "[ERROR] $num is not a Positive integer"
    else
        echo "[INFO] Time number is : $num"
        break;
    fi
done
find $add -maxdepth 1 -mtime +$((30*$num)) -type f -print > txt.log

echo "                       Eligible documents                    "
echo "-------------------------------------------------------------"
if [ -s txt.log ]; then
    find $add -maxdepth 1 -mtime +$((30*$num)) -type f -print

    read -er -n1 -p "[INFO] Proceed? [Y/n] "  tem
    if [ "$tem" == 'y' -o "$tem" == 'Y' ]; then
        find $add -maxdepth 1 -mtime +$((30*$num)) -type f -exec rm -f {} \;
        echo "[INFO] All done!"
    else
        echo "[INFO] Exit"
        rm -f txt.log
        exit 1
    fi
else
    echo "[INFO]             NO"
    echo "[INFO] Exit"
fi
rm -f txt.log



#find /root/hj -maxdepth 1 -mtime +27 -type f -exec rm -f {} \;
#find /etc -maxdepth 1 -mtime +27 -type f -print
#
#
#find /etc -maxdepth 1 -mtime +27 -type f -print