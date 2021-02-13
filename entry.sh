#!/usr/bin/env bash

# /bin/sleep inf
dpkg-reconfigure debconf
export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get -y install cron rsyslog mailutils postfix
service rsyslog start
service postfix start
/usr/bin/crontab crontab.txt
/usr/sbin/cron -f -l 8
