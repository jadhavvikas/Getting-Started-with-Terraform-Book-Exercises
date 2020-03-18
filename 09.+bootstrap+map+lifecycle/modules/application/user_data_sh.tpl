#!/usr/bin/bash
sudo yum install ${packages} -y
echo "${nameserver}" >> /etc/resolv.conf
sudo echo "<h1>"Servidor Web Rodando"</h1>" > /var/www/html/index.html
sudo service httpd start