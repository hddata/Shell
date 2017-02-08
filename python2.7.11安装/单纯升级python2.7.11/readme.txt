准备：挂载yum
脚本里的yum是我本地的配置，可自行修改，已经配置好的，可以删掉这几句话
上传python_.zip包  位置没要求


执行脚本
进入当前目录
chmod 755 python_install.sh
. ./python_install.sh  （注：点+空格+点/python_install.sh ）
source ./python_install.sh  （注：source+空格+点/python_install.sh ）
两种执行方式实质是一样


脚本内容，按照安装顺序：
1 升级python2.7.11
2 安装setuptools-23.1.0
3 安装pip-8.1.2
4 配置~/.pip/pip.conf文件
5 安装virtualenv-15.0.3
6 安装wheel-0.29.0

