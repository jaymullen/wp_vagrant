
    export DEBIAN_FRONTEND=noninteractive
    apt-get -q -y update

    # install apache... is it already installed and running?
    sudo apt-get install -y apache2

    # Copy apache configuration from local
    cp "/vagrant/config-apache.conf" "/etc/apache2/sites-enabled/000-default.conf"

    # enable mod rewrite
    sudo a2enmod rewrite

    sudo rm -rf /var/www/html
    sudo ln -fs /vagrant/www /var/www/html

    # MySQL
    #
    # Use debconf-set-selections to specify the default password for the root MySQL
    # account. This runs on every provision, even if MySQL has been installed. If
    # MySQL is already installed, it will not affect anything.
    sudo echo mysql-server mysql-server/root_password password "root" | debconf-set-selections
    sudo echo mysql-server mysql-server/root_password_again password "root" | debconf-set-selections

    apt-get -q -y install mysql-server
    apt-get -q -y install mysql-client

    # Copy mysql configuration from local
    cp "/vagrant/database/my.cnf" "/etc/mysql/my.cnf"
    cp "/vagrant/database/root-my.cnf" "/home/vagrant/.my.cnf"

    echo " * Copied /vagrant/database/mysql-config/my.cnf               to /etc/mysql/my.cnf"
    echo " * Copied /vagrant/database/mysql-config/root-my.cnf          to /home/vagrant/.my.cnf"

    sudo service mysql restart
    sleep 5
    
    mysql --user=root --password=root information_schema < /vagrant/database/init.sql
    mysql --user=root --password=root wp_app < /vagrant/database/database.sql

    # install php
    # need to restart apache for php5-mysql to take effect
    sudo apt-get install -y php5-common libapache2-mod-php5 php5-cli php5-mysql
    sudo /etc/init.d/apache2 restart
