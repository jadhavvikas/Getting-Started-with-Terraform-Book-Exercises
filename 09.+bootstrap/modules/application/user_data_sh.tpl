#!/usr/bin/bash
sudo yum install ${packages} -y
echo "${nameserver}" >> /etc/resolv.conf
sudo service httpd start