#!/bin/bash
IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
REGION=$(curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}')

yum -y update
yum install -y epel-release ; yum install -y nginx vim
systemctl start nginx ; systemctl enable nginx

for i in index;
 do ping -c1 $IP;
  echo $IP > /usr/share/doc/HTML/index.html;
  echo $REGION >> /usr/share/doc/HTML/index.html
  systemctl restart nginx
  echo "done";
   done
