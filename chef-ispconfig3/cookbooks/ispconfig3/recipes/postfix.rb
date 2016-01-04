#
# Cookbook Name:: ispconfig3
# Recipe:: postfix
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

# Install packages
%w{
    postfix-mysql
    postfix-doc
    mariadb-client
    mariadb-server
    openssl
    getmail4
    rkhunter
    binutils
    dovecot-imapd
    dovecot-pop3d
    dovecot-mysql
    dovecot-sieve
    sudo
}.each do |pkg|
    package pkg do
        action :install
    end
end

# Open the TLS/SSL and submission ports in Postfix
template '/etc/postfix/master.cf' do
    source 'master.cf.erb'
    notifies :restart, 'service[postfix]'
end

# Open the TLS/SSL and submission ports in Postfix
template '/etc/mysql/mariadb.conf.d/mysqld.cnf' do
    source 'mysqld.cnf.erb'
end

unless !File.exists?('/tmp/.mysql_secure_installation_complete')
    root_password = node['mysql_user']['root']['password']

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
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('#{root_password}');
SET PASSWORD FOR 'root'@'127.0.0.1' = PASSWORD('#{root_password}');
SET PASSWORD FOR 'root'@'::1' = PASSWORD('#{root_password}');
FLUSH PRIVILEGES;
EOF
        EOH
    end

    service "mysql" do
        action :restart
    end
end
