#!/usr/bin/bash
sudo yum install ${packages} -y
echo "${nameserver}" >> /etc/resolv.conf
sudo echo "<h1>"Tartarugas"</h1>" >> /var/www/html/index.html
sudo echo "<h1>"${id}"</h1>" >> /var/www/html/index.html
sudo echo "<h1>"${elemento}"</h1>" >> /var/www/html/index.html
sudo service httpd start