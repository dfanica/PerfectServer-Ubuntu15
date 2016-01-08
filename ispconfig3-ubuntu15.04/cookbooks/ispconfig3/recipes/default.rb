#
# Cookbook Name:: ispconfig3
# Recipe:: default
#
# Copyright 2016, Daniel Fanica
#
# All rights reserved
#


# ==================
# Preliminary Note
# ==================
# This recipe was made based on this tutorial
# https://www.howtoforge.com/tutorial/perfect-server-ubuntu-15.04-with-apache-php-myqsl-pureftpd-bind-postfix-doveot-and-ispconfig/

# export the DEBIAN_FRONTEND variable
magic_shell_environment 'DEBIAN_FRONTEND' do
    value 'noninteractive'
end

# Force owner and permissions to `/tmp` to prevent issues along the way
directory '/tmp' do
    owner 'root'
    group 'root'
    mode '1777'
end


# ===============================================================
# Edit /etc/apt/sources.list And Update Your Linux Installation
# ===============================================================

# Edit /etc/apt/sources.list. Make sure that the universe and multiverse repositories are enabled.
template '/etc/apt/sources.list' do
    source 'sources.list.erb'
end

# apt-get update && upgrade
include_recipe 'hostupgrade::upgrade'


# ==============================
# Synchronize the System Clock
# ==============================

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


# ==========================
# Change The Default Shell
# ==========================

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


# ===================================================================
# Install Postfix, Dovecot, MariaDB, phpMyAdmin, rkhunter, binutils
# ===================================================================

# Stop and disable sendmail
include_recipe 'sendmail::remove'

# Create a self-signed SSL certificate? <-- yes
# Host name: <-- example.com
# General type of mail configuration: <-- Internet Site
# System mail name: <-- example.com
[
    "dovecot-core dovecot-core/create-ssl-cert boolean true",
    "dovecot-core dovecot-core/ssl-cert-name string #{node['ispcongif']['hostname']}",
    "postfix postfix/main_mailer_type select Internet Site",
    "postfix postfix/mailname string #{node['ispcongif']['hostname']}"
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

# mysql_secure_installation
#
# Enter current password for root (enter for none): <-- press enter
# Set root password? [Y/n] <-- y
# New password: <-- Enter the new MariaDB root password here
# Re-enter new password: <-- Repeat the password
# Remove anonymous users? [Y/n] <-- y
# Disallow root login remotely? [Y/n] <-- y
# Reload privilege tables now? [Y/n] <-- y
execute 'Securing/Cleaning... Set root password in MariaDB' do
    command "sh /tmp/mysql_secure.sh"
end

service 'mysql' do
    action :restart
end


# ===============================================
# Install Amavisd-new, SpamAssassin, And Clamav
# ===============================================

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
            /AllowSupplementaryGroups /,
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


# ===================================================================================
# Install Apache2, PHP5, phpMyAdmin, FCGI, suExec, Pear, mcrypt, Opcode and PHP-FPM
# ===================================================================================

# Web server to reconfigure automatically: <-- apache2
# Configure database for phpmyadmin with dbconfig-common? <-- Yes
# Password of the database's administrative user: <-- MySQL root password here.
# MySQL application password for phpmyadmin: <-- Press enter
[
    "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2",
    "dbconfig-common dbconfig-common/dbconfig-install boolean true",
    "phpmyadmin phpmyadmin/mysql/admin-pass password #{node['mysql']['root_password']}",
    "phpmyadmin phpmyadmin/mysql/app-pass password"
].each do |selection|
    execute "echo #{selection} | debconf-set-selections"
end

# Install required packages
%w{
    apache2
    apache2-doc
    apache2-utils
    libapache2-mod-php5
    php5
    php5-common
    php5-gd
    php5-mysql
    php5-imap
    phpmyadmin
    php5-cli
    php5-cgi
    libapache2-mod-fcgid
    apache2-suexec
    php-pear
    php-auth
    php5-mcrypt
    mcrypt
    php5-imagick
    imagemagick
    libapache2-mod-suphp
    libruby
    libapache2-mod-python
    php5-curl
    php5-intl
    php5-memcache
    php5-memcached
    php5-ming
    php5-ps
    php5-pspell
    php5-recode
    php5-sqlite
    php5-tidy
    php5-xmlrpc
    php5-xsl
    php5-apcu
    memcached
    libapache2-mod-fastcgi
    php5-fpm
}.each do |pkg|
    package pkg do
        action :install
    end
end

# Enable the Apache modules suexec, rewrite, ssl, actions
execute 'apache: enable modules suexec, rewrite, ssl, actions' do
    command 'a2enmod suexec rewrite ssl actions include cgi'
    ignore_failure true
end

# ...and include (plus dav, dav_fs, and auth_digest if you want to use WebDAV)
execute 'apache: enable modules dav, dav_fs, auth_digest' do
    command 'a2enmod dav_fs dav auth_digest'
    ignore_failure true
end

# enable module mod_fastcgi
execute 'apache: enable mod_fastcgi' do
    command 'a2enmod actions fastcgi alias'
    ignore_failure true
end

# Enable the mcrypt module in PHP
execute 'php: enable mcrypt module' do
    command 'php5enmod mcrypt'
    ignore_failure true
end

# to host Ruby files with the extension .rb on the web sites created through ISPConfig,
# we must comment out the line `application/x-ruby rb` in /etc/mime.types
ruby_block "to enable ruby files on webserver" do
    block do
        rc = Chef::Util::FileEdit.new("/etc/mime.types")
        rc.search_file_replace_line(
            /^application\/x-ruby/,
            "# application/x-ruby rb"
        )
        rc.write_file
    end
end

# Remove `<FilesMatch "\.ph(p3?|tml)$">` section from suphp.conf
template '/etc/apache2/mods-available/suphp.conf' do
    source 'suphp.conf.erb'
end

service 'apache2' do
    action :restart
end


# =================
# Install Mailman
# =================

# Languages to support: <-- en (English)
# Missing site list <-- Ok
[
    "mailman mailman/create_site_list note en",
    "mailman mailman/used_languages string Ok"
].each do |selection|
    execute "echo #{selection} | debconf-set-selections"
end

package 'mailman' do
    action :install
end

# Before we can start Mailman, a first mailing list called mailman must be created
ispconfig3_mailman_list node['mailman']['list_name'] do
    email node['mailman']['email']
    password node['mailman']['password']
    action :create
end

# Start the Mailman daemon
service 'mailman' do
    action [:enable, :start]
end

template '/etc/aliases' do
    source 'aliases.erb'
end

execute 'newaliases' do
    notifies :restart, 'service[postfix]'
end

# enable the Mailman Apache configuration
link '/etc/apache2/conf-available/mailman.conf' do
    to '/etc/mailman/apache.conf'
    link_type :symbolic
    notifies :restart, 'service[apache2]'
    notifies :restart, 'service[mailman]'
end


# ============================
# Install PureFTPd And Quota
# ============================

# Install packages
%w{
    pure-ftpd-common
    pure-ftpd-mysql
    quota
    quotatool
}.each do |pkg|
    package pkg do
        action :install
    end
end

# make sure that the start mode is set to standalone and set VIRTUALCHROOT=true
ruby_block "to make sure that the start mode is set to standalone" do
    block do
        rc = Chef::Util::FileEdit.new("/etc/default/pure-ftpd-common")
        rc.search_file_replace_line(/STANDALONE_OR_INETD/, "STANDALONE_OR_INETD=standalone")
        rc.search_file_replace_line(/VIRTUALCHROOT/, "VIRTUALCHROOT=true")
        rc.write_file
    end
end

# to allow FTP and TLS sessions
execute 'echo 1 > /etc/pure-ftpd/conf/TLS'

# In order to use TLS, we must create an SSL certificate.
# Create it in /etc/ssl/private/, therefore create the directory first
directory '/etc/ssl/private/' do
    owner 'root'
    group 'ssl-cert'
    mode '0755'
    action :create
end

# openssl req -x509 -nodes -days 7300 -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem
#
# Country Name (2 letter code) [AU]: <-- Enter your Country Name (e.g., "DE").
# State or Province Name (full name) [Some-State]:<-- Enter your State or Province Name.
# Locality Name (eg, city) []:<-- Enter your City.
# Organization Name (eg, company) [Internet Widgits Pty Ltd]:<-- Enter your Organization Name (e.g., the name of your company).
# Organizational Unit Name (eg, section) []:<-- Enter your Organizational Unit Name (e.g. "IT Department").
# Common Name (eg, YOUR name) []:<-- Enter the Fully Qualified Domain Name of the system (e.g. "server1.example.com").
# Email Address []:<-- Enter your Email Address.
pureftpd_pem_cert = '/etc/ssl/private/pure-ftpd.pem'

template "/tmp/pure_ftpd_ssl_cert.sh" do
    source "pure_ftpd_ssl_cert.sh.erb"
    variables(
        pureftpd_pem_cert: pureftpd_pem_cert,
        ssl_cert_country: node['ssl_cert']['country'],
        ssl_cert_state: node['ssl_cert']['state'],
        ssl_cert_locality: node['ssl_cert']['locality'],
        ssl_cert_organisation: node['ssl_cert']['organisation'],
        ssl_cert_organisation_unit: node['ssl_cert']['organisation_unit'],
        ssl_cert_common_name: node['ssl_cert']['common_name'],
        ssl_cert_email_address: node['ssl_cert']['email_address']
    )
    not_if { ::File.exists?(pureftpd_pem_cert) }
end

file pureftpd_pem_cert do
    mode '0600'
end
service "pure-ftpd-mysql" do action :start end

# Add `usrjquota=quota.user,grpjquota=quota.group,jqfmt=vfsv0` to the partition with the mount point /
# sed -i '/tmpfs/!s/defaults/defaults,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0/' /etc/fstab
execute 'usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0 to /etc/fstab' do
    command "sed -i '/tmpfs/!s/defaults/defaults,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0/' /etc/fstab"
    only_if ("cat /etc/fstab | grep ',usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0'")
end

# enable quota
execute 'mount -o remount /'

execute 'quotacheck -avugm' do
    command 'quotacheck -avugm > /dev/null 2>&1'
    ignore_failure true
end

execute 'quotaon -avug' do
    command 'quotaon -avug > /dev/null 2>&1'
    ignore_failure true
end


# =========================
# Install BIND DNS Server
# =========================

# Install packages
%w{
    bind9
    dnsutils
}.each do |pkg|
    package pkg do
        action :install
    end
end


# =========================================
# Install Vlogger, Webalizer, And AWstats
# =========================================

# Install packages
%w{
    vlogger
    webalizer
    awstats
    geoip-database
    libclass-dbi-mysql-perl
}.each do |pkg|
    package pkg do
        action :install
    end
end

file '/etc/cron.d/awstats' do content '' end


# =================
# Install Jailkit
# =================

# Install packages
%w{
    build-essential
    autoconf
    automake1.9
    libtool
    flex
    bison
    debhelper
    binutils-gold
}.each do |pkg|
    package pkg do
        action :install
    end
end

# Jailkit is needed only if you want to chroot SSH users
# http://olivier.sessink.nl/jailkit/jailkit-2.17.tar.gz
tar_package 'http://olivier.sessink.nl/jailkit/jailkit-2.17.tar.gz' do
    prefix '/tmp'
    creates '/tmp/jailkit'
end


# ==================
# Install fail2ban
# ==================

package 'fail2ban' do
    action :install
end

service "fail2ban" do
  supports [ :status => true, :restart => true ]
  action [ :enable, :start ]
end

template '/etc/fail2ban/jail.local' do
    source 'jail.local.erb'
    owner 'root'
    group 'root'
    mode 0400
end

template '/etc/fail2ban/filter.d/pureftpd.conf' do
    source 'pureftpd.conf.erb'
end

template '/etc/fail2ban/filter.d/dovecot-pop3imap.conf' do
    source 'dovecot-pop3imap.conf.erb'
end

# istead of 'echo "ignoreregex =" >> /etc/fail2ban/filter.d/postfix-sasl.conf'
template '/etc/fail2ban/filter.d/postfix-sasl.conf' do
    source 'postfix-sasl.conf.erb'
    notifies :restart, "service[fail2ban]"
end
