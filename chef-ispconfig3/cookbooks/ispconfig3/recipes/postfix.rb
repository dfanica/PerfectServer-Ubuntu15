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
    source 'postfix/master.cf.erb'
    notifies :restart, 'service[postfix]'
end

# Open the TLS/SSL and submission ports in Postfix
template ::File.join(node['ispconfig3']['mariadb_mysql_path'], 'mysqld.cnf') do
    source 'postfix/mysqld.cnf.erb'
end

package 'mysql_secure_installation' do
    description 'Secure MySQL installation'
    requires :mysql_core
    apt 'expect'
    local_file = 'mysql_secure_installation_no_ask'
    remote_file = '/usr/local/mysql/scripts/mysql_secure_installation_no_ask'
    transfer local_file, remote_file do
        pre :install, 'mkdir -p /usr/local/mysql/scripts'
        post :install, "chmod +x #{remote_file}"
        post :install, remote_file
    end
    verify do
        has_file remote_file
    end
    notifies :restart, 'service[mysql]'
end
