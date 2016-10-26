#!/bin/bash
#更新源
yum update 

#安装python3.4,可以和python2共存

#编译需要的一些包，酌情安装
yum groupinstall "Development tools"
yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-deve
 
#下载解压并编译
# 国内源http://mirrors.sohu.com/python/3.4.3/Python-3.4.3.tgz
wget https://www.python.org/ftp/python/3.4.3/Python-3.4.3.tgz
tar xf Python-3.4.3.tgz
cd Python-3.4.3
./configure --prefix=/usr/local --enable-shared
make
#请勿使用make install
make altinstall

#链接库文件
echo /usr/local/lib >> /etc/ld.so.conf.d/local.conf
ldconfig

#删除python安装包
cd ..
rm -rf Python-3.4*

#重启后生效
echo "Please reboot your server and then run the setup script--'./run.sh'"
