#
# Cookbook Name:: ispconfig3
# Recipe:: default
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
template ::File.join(node['ispconfig3']['postfix_path'], 'master.cf') do
    source 'master.cf.erb'
    notifies :restart, 'service[postfix]'
end

#--------------------------------------------------
# mysql_secure_installation 5.5
#--------------------------------------------------
# 4. Set root password? [Y/n] Y
# 1. Remove anonymous users? [Y/n] Y
# 3. Disallow root login remotely? [Y/n] Y
# 2. Remove test database and access to it? [Y/n] Y
# 5. Reload privilege tables now? [Y/n] Y

root_password = node['mysql_user']['root']['password']
bash "mysql_secure_installation" do
  code <<-EOC
    mysql -u root -e "DELETE FROM mysql.user WHERE User='';"
    mysql -u root -e "DROP DATABASE test;"
    mysql -u root -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
    mysql -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    mysql -u root -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('#{root_password}');" -D mysql
    mysql -u root -p#{root_password} -e "SET PASSWORD FOR 'root'@'127.0.0.1' = PASSWORD('#{root_password}');" -D mysql
    mysql -u root -p#{root_password} -e "SET PASSWORD FOR 'root'@'::1' = PASSWORD('#{root_password}');" -D mysql
    mysql -u root -p#{root_password} -e "FLUSH PRIVILEGES;"
  EOC
  only_if "mysql -u root -e 'show databases'"
end

# Open the TLS/SSL and submission ports in Postfix
template ::File.join(node['ispconfig3']['mariadb_mysql_path'], 'mysqld.cnf') do
    source 'mysqld.cnf.erb'
    notifies :restart, 'service[mysql]'
end
