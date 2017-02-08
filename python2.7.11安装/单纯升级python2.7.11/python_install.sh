#! /bin/bash

#升级python
#2016-12-20 python_install.sh -v1.1
export PATH=$PATH:/usr/local/python-2.7.11/bin

PYTHON="/usr/local/src"
PYTHON_PATH="$PYTHON/Python-2.7.11"
Logfile="$PYTHON_PATH/log"

check()
{
  if [ $? -ne 0 ]
  then
    echo "[ERROR] $0 ERROR"
    exit 1
  else
    echo "[INFO] Successfully installed $1"
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

install_targz()
{
  cd $PYTHON
  checkFile $1
  tem=$1
  Na=${tem%.tar.gz*}
  log=$Na"_.log"
  tar -zxvf $1 &>$Logfile/$log
  cd $Na
  python setup.py install &>>$Logfile/$log
  check $Na  
}

install_whl()
{
  cd $PYTHON
  checkFile $1
  tem=$1
  Na=${tem%-py2*}
  log=$Na"_.log"
  pip install $1 &>>$Logfile/$log
  check $Na
}

cp /etc/yum.repos.d/RHEL.repo /etc/yum.repos.d/RHEL_cp.repo
echo -n "[RHEL]
enabled=1
gpgcheck=0
name=RHEL
baseurl=ftp://172.16.120.13/yumsource/RHEL/RHEL6.7

[EPEL]
enabled=1
gpgcheck=0
name=EPEL
baseurl=ftp://172.16.120.13/yumsource/epel

[openssl]
enabled=1
gpgcheck=0
name=openssl
baseurl=ftp://172.16.120.13/yumsource/bugfix/CVE-2016-2108/RHEL6
"> /etc/yum.repos.d/RHEL.repo
yum clean all
yum makecache

read -p "Input pypi address-->add1: "  add
if [ -n "$add" ]; then
  #非空
  read -p "Again input pypi address-->add2: "  add1
  if [ "$add"x = "$add1"x ]; then
    echo "pypi address：$add"
  else
    echo "add1：$add"
    echo "add2：$add1"
    read -p "Continue:yes--y "  tem
    if [ "$tem" == 'y' -o "$tem" == 'Y' ]; then
      while [  "$add" != "$add1" ]; do
        read -p "Input pypi address:  "  add
        read -p "Again input pypi address:"  add1
      done
    else 
      add=""
    fi
  fi
else
  echo "No pypi address"
fi

mkdir -p $Logfile
yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel gcc -y &>>$Logfile/yum_.log
if [ $? -ne 0 ]
  then
    echo "[ERROR] yum error"
    exit 1
fi

#python install
find / -name "python_.zip"  -type f -exec cp {} $PYTHON \; &>>$Logfile/python_.log
cd $PYTHON
unzip python_.zip -d $PYTHON &>>$Logfile/python_.log
#mv $PYTHON/python_/* $PYTHON

checkFile Python-2.7.11.tgz
tar zxvf Python-2.7.11.tgz &>>$Logfile/python_.log
cd $PYTHON_PATH
./configure --prefix=/usr/local/python-2.7.11 &>>$Logfile/python_.log
make &>>$Logfile/python_.log
make install &>>$Logfile/python_.log
check Python-2.7.11
#
cd /usr/bin/
rm -rf python
ln -s /usr/local/python-2.7.11/bin/python ./python
echo "PATH=$PATH:/usr/local/python-2.7.11/bin">>/etc/profile
. /etc/profile
sed -i '1c #!/usr/bin/python2.6' /usr/bin/yum
#setuptools install
install_targz setuptools-23.1.0.tar.gz
install_targz pip-8.1.2.tar.gz

if [ -n "$add" ]; then
  #非空
  temp=${add#*//}
  var=${temp%/*}
  mkdir -p ~/.pip
  echo -e "[global]\nindex-url = $add\ntrusted-host = $var">~/.pip/pip.conf
  pip &> $Logfile/tem.txt
  if cat $Logfile/tem.txt | grep "pip <command>" >/dev/null
  then
    echo "[INFO] pip configured success"
  else
    echo "[ERROR] "
  fi
  rm -rf $Logfile/tem.txt 
fi

install_targz virtualenv-15.0.3.tar.gz
install_whl wheel-0.29.0-py2.py3-none-any.whl

mkdir -p /root/work
cd /root/work
virtualenv env
source env/bin/activate
deactivate
if [ $? -ne 0 ]
    then
    echo "[ERROR] virtualenv"
else
    echo "[INFO] virtualenv"
fi