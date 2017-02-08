#! /bin/bash

OGG_status="$OGG_HOME/Status____ogg"
mkdir -p $OGG_status
echo "info all">$OGG_status/info.txt

cd $OGG_HOME
./ggsci<$OGG_status/info.txt>$OGG_status/status1.txt
sed -n '/Status/,$p' $OGG_status/status1.txt>$OGG_status/status12.txt
sed  -i '/^$/d' $OGG_status/status12.txt
sed -i '1,2d' $OGG_status/status12.txt
sed -i '$d' $OGG_status/status12.txt
awk '{print $2,$3"\n"}' $OGG_status/status12.txt >$OGG_status/status13.txt
sed  -i '/^$/d' $OGG_status/status13.txt
num=`sed -n '$=' $OGG_status/status13.txt`

if [ $num -eq 0 ];then
    echo "no group"
else
    for i in `seq $num`;do
        awk ''NR==$i' {print $2}' $OGG_status/status13.txt>$OGG_status/temp.txt 
        j=`cat $OGG_status/temp.txt | sed 's/^[[:space:]]*//'` 
        echo "info $j">$OGG_status/info.txt 
        ./ggsci<$OGG_status/info.txt>$OGG_status/status2.txt
        grep -A 5 'Checkpoint Lag' $OGG_status/status2.txt>$OGG_status/status21.txt

        sed -i '/Checkpoint Lag/d' $OGG_status/status21.txt
        sed -i '/Log Number/d' $OGG_status/status21.txt
        sed -i '/Record Offset/d' $OGG_status/status21.txt
        sed -i '/^ *$/d' $OGG_status/status21.txt

        ti=`grep ":*:" $OGG_status/status21.txt`
        echo $ti | tr -d "a-zA-Z" >$OGG_status/status21.txt
        tie=`sed 's/^[ \t]*//g' $OGG_status/status21.txt`
        echo ${tie:0:19} >$OGG_status/status14.txt
        awk ''NR==$i' {print $1,$2}' $OGG_status/status13.txt>$OGG_status/tem.txt 
        cat $OGG_status/status14.txt>>$OGG_status/tem.txt
        sed ':a ; N;s/\n/ / ; t a ; ' $OGG_status/tem.txt>$OGG_status/status.txt
#
        cat $OGG_status/status.txt>>$OGG_status/status_.txt
    done
fi

nowtime=`date +"%Y-%m-%d %H:%M:%S"`
echo "present time："$nowtime
echo "Status  Name  Time    "
cat $OGG_status/status_.txt

echo ""
echo "rm file " $OGG_status"/"
rm -r $OGG_status
