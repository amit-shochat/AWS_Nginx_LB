#!/bin/bash

echo "amit" >>./amit
yum -y update ; echo "update" >>./amit
yum install -y epel-release ; echo "install-epel" >>./amit
yum install -y nginx ; echo "install nginx" >>./amit
yum install -y vim ; echo "install-vim" >>./amit
systemctl start nginx ; echo "start-nginx" >>./amit
systemctl enable nginx ; echo "enable-nginx" >>./amit

for i in index; do sleep 7; echo "sleep"; done

echo "
#!/bin/bash
sudo su
echo "AWS nginx WEB server" > /usr/share/doc/HTML/index.html
echo $(ifconfig eth0 | grep "inet" | cut -d: -f2 | awk '{print $2}') >> /usr/share/doc/HTML/index.html
" >>/.nginx_html.sh

chmod +x /.nginx_html.sh
bash /.nginx_html.sh

systemctl restart  nginx ; echo "restart nginx" >> ./amit