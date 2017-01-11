#! /bin/bash

#执行前确保yum可以正常使用，没有挂载的话mount /dev/cdrom  /media挂载
#网络可以正常使用  echo "nameserver 8.8.8.8">> /etc/resolv.conf
#实验前上传安装包tosc
#2016-08-23--python_install.sh-v1.0


PYTHON="/usr/local/src"
PYTHON_PATH="$PYTHON/Python-2.7.11"
PYTHON_LOG="$PYTHON/Python_installlog"
TOSCD="/root/work/TOSCDev"
TOSC="$TOSCD/tosc"

check()
{
  if [ $? -ne 0 ]
  then
    echo "[ERROR]"
    exit 1
  fi
}

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

pythoninstall()
{
  #python install
  yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel gcc<$PYTHON_LOG/in.txt &>>$PYTHON_LOG/yumlog
  check
  echo "yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel gcc success"
  mv $TOSC/lg/Python-2.7.11.tgz $PYTHON
  cd $PYTHON
  checkFile Python-2.7.11.tgz
  tar zxvf Python-2.7.11.tgz>>$PYTHON_LOG/python_installlog
  cd $PYTHON_PATH
  ./configure --prefix=/usr/local/python-2.7.11 &>>$PYTHON_LOG/python_installlog
  check
  make &>>$PYTHON_LOG/python_installlog
  check
  make install &>>$PYTHON_LOG/python_installlog
  check
  #
  cd /usr/bin/
  rm -rf python
  ln -s $PYTHON_PATH/bin/python ./python
  echo "PATH=$PATH:/usr/local/python-2.7.11/bin">>/etc/profile
  check
  . /etc/profile
  sed -i '1c #!/usr/bin/python2.6' /usr/bin/yum
  ######################setuptools install
  mv $TOSC/lg/setuptools-23.1.0.tar.gz $PYTHON
  cd $PYTHON
  checkFile setuptools-23.1.0.tar.gz
  tar zxvf setuptools-23.1.0.tar.gz &>$PYTHON_LOG/setuptools_installlog
  cd setuptools-23.1.0
  python setup.py build &>>$PYTHON_LOG/setuptools_installlog
  check
  python setup.py install &>>$PYTHON_LOG/setuptools_installlog
  check
  echo "setuptools install success"
  #######################
  cd $PYTHON_PATH
  echo "python reinstall start"
  make clean &>>$PYTHON_LOG/python_installlog
  make &>>$PYTHON_LOG/python_installlog
  check
  make install &>>$PYTHON_LOG/python_installlog
  check
  echo "python install success" 
}

mkdir -p $PYTHON_LOG $TOSCD
check
echo "Y">$PYTHON_LOG/in.txt
#关闭防火墙
chkconfig iptables off
service iptables stop
check
#
cd $TOSCD
find / -name "tosc.zip"  -type f -exec mv {} /root/work/TOSCDev \; &>>$PYTHON_LOG/set.txt
check
echo "find tosc.zip"
unzip tosc.zip &>>$PYTHON_LOG/set.txt
#####
read -p "是否只安装python？是(y)---否(其他): "  tem
if [ "$tem" == 'y' -o "$tem" == 'Y' ]
  then
  pythoninstall
  exit 1
fi
########
pythoninstall
#######################pip
mv $TOSC/lg/pip-8.1.2.tar.gz $PYTHON
cd $PYTHON
checkFile pip-8.1.2.tar.gz
tar xvf pip-8.1.2.tar.gz >$PYTHON_LOG/pip_installlog
cd pip-8.1.2
python setup.py install &>>$PYTHON_LOG/pip_installlog
check
echo "pip install success"
############################ distribute
mv $TOSC/lg/distribute-0.6.10.tar.gz $PYTHON
cd $PYTHON
checkFile distribute-0.6.10.tar.gz
tar xf distribute-0.6.10.tar.gz &>$PYTHON_LOG/distribute_installlog
cd distribute-0.6.10
python setup.py install &>>$PYTHON_LOG/distribute_installlog
check
echo "distribute install success"
#####virtualenv
mv $TOSC/lg/virtualenv-15.0.3.tar.gz $PYTHON
cd $PYTHON
checkFile virtualenv-15.0.3.tar.gz
tar xvf virtualenv-15.0.3.tar.gz &>>$PYTHON_LOG/virtualenv_installlog
cd virtualenv-15.0.3
python setup.py install &>>$PYTHON_LOG/virtualenv_installlog
check
echo "virtualenv install success"
##########nose
mv $TOSC/lg/nose-1.3.7.tar.gz $PYTHON
cd $PYTHON
checkFile nose-1.3.7.tar.gz
tar xf nose-1.3.7.tar.gz &>$PYTHON_LOG/nose_installlog
cd nose-1.3.7
python setup.py install &>>$PYTHON_LOG/nose_installlog
check
echo "nose install success"
##################################################
read -p "是否继续部署项目？是(y)---否(其他): "  tem
if [ "$tem" == 'y' -o "$tem" == 'Y' ]
   then
   cd $TOSCD
   #创建 启动虚拟环境
   echo "Creating Virtual Environment"
   virtualenv toscvenv
   check
   . toscvenv/bin/activate
   cd $TOSC
#
   for i in `rpm -qa|grep -i mysql-devel`
   do
   rpm -ev $i --nodeps
   done
#
   yum install mysql-devel<$PYTHON_LOG/in.txt &>>$PYTHON_LOG/yumlog
   check
   echo "yum install mysql-devel success"
   echo "start pip install requirements.txt"
   pip install -r requirements.txt &>>$PYTHON_LOG/set.txt
   check
   pip install MySQL-python==1.2.3 &>>$PYTHON_LOG/set.txt
   check
   echo "MySQL-python==1.2.3 install success"
#退出虚拟环境
   deactivate
#前端部署
   yum -y install pcre-devel  openssl openssl-devel<$PYTHON_LOG/in.txt &>>$PYTHON_LOG/yumlog
   check
   echo "yum install pcre-devel success"
#Nginx install
   mv $TOSC/lg/nginx-1.9.9.tar.gz $PYTHON
   cd $PYTHON
   checkFile nginx-1.9.9.tar.gz
   tar -zxvf nginx-1.9.9.tar.gz &>>$PYTHON_LOG/Nginx_installlog
   cd nginx-1.9.9
   ./configure --prefix=/usr/local/nginx &>>$PYTHON_LOG/Nginx_installlog
   check
   make &>>$PYTHON_LOG/Nginx_installlog
   make install &>>$PYTHON_LOG/Nginx_installlog
   check
   echo "nginx install success"
	###
   cat /root/work/TOSCDev/tosc/lg/config.txt>/usr/local/nginx/conf/nginx.conf
fi
#####################################################################
echo "finish"