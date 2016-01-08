#
# Cookbook Name:: ispconfig3
# Recipe:: default
#
# Copyright 2016, Daniel Fanica
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

include_recipe 'zip'

# Install required packages
%w{
    amavisd-new
    spamassassin
    clamav
    clamav-daemon
    zoo
    bzip2
    arj
    nomarch
    lzop
    cabextract
    apt-listchanges
    libnet-ldap-perl
    libauthen-sasl-perl
    clamav-docs
    daemon
    libio-string-perl
    libio-socket-ssl-perl
    libnet-ident-perl
    libnet-dns-perl
}.each do |pkg|
    package pkg do
        action :install
    end
end

# The ISPConfig 3 setup uses amavisd which loads the SpamAssassin filter library internally...
# so we can stop SpamAssassin to free up some RAM
service 'spamassassin' do action [ :stop, :disable ] end

# Edit the clamd configuration file
# Set AllowSupplementaryGroups to TRUE
ruby_block "edit etc hosts" do
    block do
        rc = Chef::Util::FileEdit.new("/etc/clamav/clamd.conf")
        rc.search_file_replace_line(
            /^AllowSupplementaryGroups /,
            "AllowSupplementaryGroups true"
        )
        rc.write_file
    end
end

# stop if already running (in case server was restarted)
# this will prevent `STDOUT: ERROR: /var/log/clamav/freshclam.log is locked by another process`
service 'clamav-freshclam' do
    action :stop
end

# start clamav
execute 'freshclam'
service 'clamav-daemon' do action :start end
