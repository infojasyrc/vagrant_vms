#!/usr/bin/env bash

echo "Provisioning virtual machine..."
# ---------------------------------------
#          Virtual Machine Setup
# ---------------------------------------

echo "Adding multiverse sources."
cat > /etc/apt/sources.list.d/multiverse.list << EOF
deb http://archive.ubuntu.com/ubuntu trusty multiverse
deb http://archive.ubuntu.com/ubuntu trusty-updates multiverse
deb http://security.ubuntu.com/ubuntu trusty-security multiverse
EOF

echo "Updating packages"
apt-get update

echo "Installing GIT"
apt-get install git -y > /dev/null

echo "Installing Apache Packages"
apt-get install -y apache2 libapache2-mod-fastcgi apache2-mpm-worker

echo "Linking Vagrant directory to Apache 2.4 public directory"
rm -rf /var/www
ln -fs /vagrant /var/www

echo "Add ServerName to httpd.conf"
echo "ServerName localhost" > /etc/apache2/httpd.conf
# Setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
	ServerAdmin webmaster@localhost.com
	ServerName localhost

  	DocumentRoot "/var/www/public"
  	ErrorLog "/var/log/apache2/my_project-error_log"
    CustomLog "/var/log/apache2/my_project-access_log" common
  
  	<Directory "/var/www/public">
  		Options Indexes FollowSymLinks MultiViews
    	AllowOverride All
    	Order allow,deny
		Allow from all
  	</Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-enabled/000-default.conf

echo "Loading needed modules to make apache work"
a2enmod actions fastcgi rewrite
service apache2 reload
