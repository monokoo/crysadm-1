#!/bin/bash
#安装云监工环境脚本
#sanzuwu@gamil.com
#脚本适用centos7

#安装pip，确保本脚本和get-pip.py 文件在一个文件夹
BASE_DIR="$( cd "$( dirname "$0"  )" && pwd  )"
chmod +x ${BASE_DIR}/get-pip.py
python3.4 ${BASE_DIR}/get-pip.py

pip install redis && pip install requests && pip install flask
pip install flask-mail
pip install uwsgi

#创建uWSGI存放log目录
mkdir -p /var/log/uwsgi

#安装redis
yum install -y redis
systemctl enable redis
service redis start

#安装nginx
yum install nginx -y
ln -s /opt/crysadm/crysadm_nginx.conf /etc/nginx/conf.d/
service nginx restart

#使用随机生成的secret_key替换默认的key
python3.4 gen_random_secret_key.py > secret
secret_key=$(cat secret|awk 'NR==2 {print}')
sed -i "s/SECRET_KEY = 'sw7dWI8l-9Tw0-rcn1-vdYM-zVWoAox5q4Il'/SECRET_KEY = '${secret_key}'/" /opt/crysadm/config.py
rm -f secret

#复制开机启动脚本
cp /opt/crysadm/crysadm /etc/init.d/crysadm
chmod +x /etc/init.d/crysadm
chkconfig --add crysadm && chkconfig crysadm on
#运行云监工
service crysadm start
