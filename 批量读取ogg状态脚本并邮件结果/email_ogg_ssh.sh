#! /bin/bash
#email_ogg_ssh.sh-v1.1
#
pwd_=$(pwd)
cd $pwd_
sh $pwd_/ogg_ssh_status.sh hostlist ogg_status.sh 1>$pwd_/ogg_status.log
python $pwd_/smtplib_2.py
rm -rf $pwd_/ogg_status.log