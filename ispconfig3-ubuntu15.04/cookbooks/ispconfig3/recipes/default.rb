#
# Cookbook Name:: ispconfig3
# Recipe:: basics
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#


# ====================
# Preliminary Note
# ====================
# This recipe was made based on this tutorial
# https://www.howtoforge.com/tutorial/perfect-server-ubuntu-15.04-with-apache-php-myqsl-pureftpd-bind-postfix-doveot-and-ispconfig/

# export the DEBIAN_FRONTEND variable
magic_shell_environment 'DEBIAN_FRONTEND' do
    value 'noninteractive'
end


# =================================================================
# Edit /etc/apt/sources.list And Update Your Linux Installation
# =================================================================

# Edit /etc/apt/sources.list. Make sure that the universe and multiverse repositories are enabled.
template '/etc/apt/sources.list' do
    source 'sources.list.erb'
end

# apt-get update && upgrade
include_recipe 'hostupgrade::upgrade'


# =============================
# Synchronize the System Clock
# =============================

# Install required packages
%w{
    debconf-utils
    expect
    ntp
    ntpdate
}.each do |pkg|
    package pkg do
        action :install
    end
end


# =========================
# Change The Default Shell
# =========================

# /bin/sh is a symlink to /bin/dash, however we need /bin/bash, not /bin/dash
execute 'echo dash dash/sh boolean false | debconf-set-selections'
execute 'reconfigure dash' do
    command 'dpkg-reconfigure dash'
    action :run
    environment ({'DEBIAN_FRONTEND' => 'noninteractive'})
end

# =================
# Disable AppArmor
# =================
include_recipe 'apparmor'


# ==================================================================
# Install Postfix, Dovecot, MariaDB, phpMyAdmin, rkhunter, binutils
# ==================================================================

# Stop and disable sendmail
include_recipe 'sendmail::remove'

# You will be asked the following questions:
# Create a self-signed SSL certificate? <-- yes
# Host name: <-- example.com
# General type of mail configuration: <-- Internet Site
# System mail name: <-- example.com
[
    "dovecot-core   dovecot-core/create-ssl-cert    boolean     true",
    "dovecot-core   dovecot-core/ssl-cert-name      string      #{node['ispcongif']['hostname']}",
    "postfix        postfix/main_mailer_type        select      Internet Site",
    "postfix        postfix/mailname                string      #{node['ispcongif']['hostname']}"
].each do |selection|
    execute "echo #{selection} | debconf-set-selections"
end

%w{
    postfix
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
end

service 'postfix' do
    action :restart
end

# make MySQL listen on all interfaces
execute "sed -i 's/bind-address/#bind-address/' /etc/mysql/mariadb.conf.d/mysqld.cnf"

# Securing/Cleaning up the install
template "/tmp/mysql_secure.sh" do
    source "mysql_secure.sh.erb"
    variables(
        mysql_root_password: node['mysql']['root_password']
    )
end

execute 'Securing/Cleaning... Set root password in MariaDB' do
    command "sh /tmp/mysql_secure.sh"
end

service 'mysql' do
    action :restart
end


# ==================================================================
# Install Amavisd-new, SpamAssassin, And Clamav
# ==================================================================
