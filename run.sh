#!/bin/sh

ps -ef |grep -E 'crysadm'|grep -v grep|awk '{print $2}'|xargs kill -9

BASE_DIR="/opt/crysadm"

python3.4 ${BASE_DIR}/crysadm_helper.py >> /var/log/uwsgi/crysadm_uwsgi.log 2>&1 &
uwsgi --ini /opt/crysadm/crysadm_helper_uwsgi.ini >> /var/log/uwsgi/crysadm_uwsgi.log 2>&1 &
