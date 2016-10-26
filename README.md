#声明
云监工的原作者是powergx，有很多功能也是从别人那里merge过来的。我只是加了一些自己想要的功能。

如果没有重大bug，此版本将不再更新。如果你发现bug，或者有新的功能，可以提交pull request。



##一键脚本用法
进入系统后先升级源，输入命令<br>
`yum update` <br>
等一会自动下载，输入命令 <br>
`yum install -y git` <br>
用 `cd` 命令进入/opt目录，输入命令<br>
`cd /opt`<br>
`mkdir /opt/crysadm`<br>
`git clone https://github.com/monokoo/crysadm-1.git`<br>
`mv crysadm-1 crysadm`<br>
等待下载完成，输入命令,配置python3.4环境<br>
`cd crysadm  &&  sh install_python3.sh`<br>
配置完成之后重启服务器生效<br>
`reboot`<br>
进入系统执行setup.sh脚本<br>
`cd crysadm  && sh setup.sh`<br>
此时等待安装，完成后会自动启动云监工。<br>
请务必修改/opt/crysadm/config.py 文件secret_key的默认值。<br>
***
##PS:<br>
***
install_python3.sh是配置python3.4脚本，，setup.sh是安装环境脚本。<br>
如果同步最新代码更新执行以下命令:<br>
git pull <br>
service crysadm restart <br>
***
***

#以下为手动配置方法
# 云监工配置Nginx、uWSGI

## 安装Nginx和uWSGI

```bash
yum install nginx -y
pip install uwsgi
```

##配置Nginx
创建云监工存放目录/opt/crysadm
```bash
mkdir /opt/crysadm
```

配置文件已包含在git源码内
创建云监工使用的配置文件/opt/crysadm/crysadm_nginx.conf
```shell
server {
    listen      4000;
    server_name 0.0.0.0;
    charset     utf-8;
    client_max_body_size 75M;

    location / { try_files $uri @yourapplication; }
    location @yourapplication {
        include uwsgi_params;
        uwsgi_pass unix:/opt/crysadm/crysadm_uwsgi.sock;
    }
}
```
将配置文件符号链接到Nginx配置文件目录，重启Nginx
```bash
ln -s /opt/crysadm/crysadm_nginx.conf /etc/nginx/conf.d/
service nginx restart
```
##配置uWSGI
创建一个新的uWSGI配置文件/opt/crysadm/crysadm_helper_uwsgi.ini
```bash
[uwsgi]
#application's base folder
base = /opt/crysadm

#python module to import
app = crysadm
module = %(app)

#home = %(base)/
pythonpath = %(base)

#socket file's location
socket = /opt/crysadm/%n.sock

#permissions for the socket file
chmod-socket    = 666

#the variable that holds a flask application inside the module imported at line #6
callable = app

#location of log files
logto = /var/log/uwsgi/%n.log
```
创建uWSGI存放log目录
```bash
mkdir -p /var/log/uwsgi
```
##克隆云监工代码
```bash
cd /opt/
git clone https://github.com/monokoo/crysadm-1.git
mv crysadm-1 crysadm
```
如果你是第一次部署，首先要启动redis-server
```bash
service redis start
```
运行云监工
```bash
./opt/crysadm/run.sh
```

可以通过浏览器访问云监工了，默认的使用的端口是4000

访问服务器IP:4000/install 生成管理员账号密码，只有一次机会。如果忘了，把数据库数据删除重新加载这个页面。

