准备：挂载yum
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


测试源地址
https://pypi.python.org/simple
http://127.0.0.1/simple

脚本结束后第一次使用python的办法
1：执行语句  . /etc/profile
2：重新开一个窗口
注：python的环境已经写入环境变量的文件，刷新的语句在脚本里的时候，环境变量只有在脚本里才有效。脚本结束后就回到脚本执行前的环境。
