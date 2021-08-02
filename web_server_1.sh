#!/bin/bash

echo "TEST_file" >>./test
yum -y update ; echo "update" >>./test
yum install -y epel-release ; echo "install-epel" >>./test
yum install -y nginx vim ; echo "install nginx" >>./test
systemctl start nginx ; echo "start-nginx" >>./test
systemctl enable nginx ; echo "enable-nginx" >>./test

for i in index; do sleep 7; echo "sleep"; done

echo "
#!/bin/bash
sudo su
echo "AWS nginx WEB server" > /usr/share/doc/HTML/index.html
echo $(ifconfig eth0 | grep "inet" | cut -d: -f2 | awk '{print $2}') >> /usr/share/doc/HTML/index.html
" >>/.nginx_html.sh

chmod +x /.nginx_html.sh
bash /.nginx_html.sh

systemctl restart  nginx ; echo "restart nginx" >> ./test
