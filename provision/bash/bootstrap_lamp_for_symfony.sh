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

echo "Installing Git PPA"
add-apt-repository -y ppa:git-core/ppa > /dev/null

echo "Adding NodeJS PPA"
add-apt-repository -y ppa:chris-lea/node.js > /dev/null

echo "Updating packages"
apt-get -y update > /dev/null

echo "Installing bindfs"
apt-get install -y bindfs > /dev/null

echo "Installing git, vim and curl"
apt-get install -y git vim curl > /dev/null

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
ErrorLog "/var/log/apache2/my_project-error.log"
CustomLog "/var/log/apache2/my_project-access.log" common

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

# ---------------------------------------
#          PHP Setup
# ---------------------------------------

echo "Installing PHP packages"
apt-get install -y php5 php5-cli php5-fpm php5-curl php5-mcrypt php5-xdebug php5-gd php5-apcu php5-json php5-readline > /dev/null

echo "Creating the configurations inside Apache"
cat > /etc/apache2/conf-available/php5-fpm.conf << EOF
<IfModule mod_fastcgi.c>
AddHandler php5-fcgi .php
Action php5-fcgi /php5-fcgi
Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi
FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi -socket /var/run/php5-fpm.sock -pass-header Authorization

# NOTE: using '/usr/lib/cgi-bin/php5-cgi' here does not work,
#   it doesn't exist in the filesystem!
<Directory /usr/lib/cgi-bin>
Require all granted
</Directory>

</IfModule>
EOF

echo "Enabling php modules"
php5enmod mcrypt

echo "Triggering changes in apache"
a2enconf php5-fpm
service apache2 reload

# ---------------------------------------
#          MySQL Setup
# ---------------------------------------

# Setting MySQL root user password root/root
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

echo "Installing MySQL packages"
apt-get install -y mysql-server mysql-client php5-mysql > /dev/null

# ---------------------------------------
#          PHPMyAdmin setup
# ---------------------------------------

# Default PHPMyAdmin Settings
debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password root'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password root'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password root'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'

echo "Install PHPMyAdmin"
apt-get install -y phpmyadmin > /dev/null

echo "Copy PHPMyAdmin site"
ln -s /etc/phpmyadmin/apache.conf /etc/apache2/sites-enabled/phpmyadmin.conf

echo "Restarting apache to make changes"
service apache2 restart > /dev/null

# ---------------------------------------
#       Tools Setup
# ---------------------------------------

echo "Installing nodejs and npm"
apt-get install -y nodejs > /dev/null

echo "Installing Bower and Grunt"
npm install -g bower grunt-cli > /dev/null

echo "Installing Composer"
curl -s https://getcomposer.org/installer | php > /dev/null

echo "Make Composer available globally"
mv composer.phar /usr/local/bin/composer
