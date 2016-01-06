#
# Cookbook Name:: ispconfig3
# Recipe:: mariadb
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

bash 'installing MariaDB...' do
    code <<-EOH
        echo "mysql-server-5.5 mysql-server/root_password password #{node['mysql']['root_password']}" | debconf-set-selections
        echo "mysql-server-5.5 mysql-server/root_password_again password #{node['mysql']['root_password']}" | debconf-set-selections
        apt-get -y install mariadb-client mariadb-server > /dev/null 2>&1
    EOH
end

# Open the TLS/SSL and submission ports in Postfix
execute "sed -i 's/bind-address/#bind-address/' /etc/mysql/mariadb.conf.d/mysqld.cnf"
# template '/etc/mysql/mariadb.conf.d/mysqld.cnf' do
#     source 'mysqld.cnf.erb'
# end

unless File.exists?('/tmp/.mysql_secure_installation_complete')
    #--------------------------------------------------
    # mysql_secure_installation 5.5
    #--------------------------------------------------
    # 4. Set root password? [Y/n] Y
    # 1. Remove anonymous users? [Y/n] Y
    # 3. Disallow root login remotely? [Y/n] Y
    # 2. Remove test database and access to it? [Y/n] Y
    # 5. Reload privilege tables now? [Y/n] Y
    bash 'mysql_secure_installation' do
        code <<-EOH
            mysql -uroot <<EOF && touch /tmp/.mysql_secure_installation_complete
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('#{node['mysql']['root_password']}');
SET PASSWORD FOR 'root'@'127.0.0.1' = PASSWORD('#{node['mysql']['root_password']}');
SET PASSWORD FOR 'root'@'::1' = PASSWORD('#{node['mysql']['root_password']}');
FLUSH PRIVILEGES;
EOF
        EOH
    end

    service "mysql" do
        action :restart
    end
end
