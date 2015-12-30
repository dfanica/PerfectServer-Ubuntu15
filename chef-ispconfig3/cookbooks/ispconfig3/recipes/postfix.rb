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
    notifies :restart, 'service[mysql]'
end
