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
template '/etc/postfix/master.cf' do
    source 'master.cf.erb'
    notifies :restart, 'service[postfix]'
end

# Open the TLS/SSL and submission ports in Postfix
template '/etc/mysql/mariadb.conf.d/mysqld.cnf' do
    source 'mysqld.cnf.erb'
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
service "mysql" do action :restart end


#--------------------------------------------------
# Install Amavisd-new, SpamAssassin, And Clamav
#--------------------------------------------------

# Install packages
%w{
    amavisd-new
    spamassassin
    clamav
    clamav-daemon
    zoo
    unzip
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
    zip
    libnet-dns-perl
}.each do |pkg|
  package pkg do
    action :install
  end
end

# The ISPConfig 3 setup uses amavisd which loads the SpamAssassin filter library internally...
# so we can stop SpamAssassin to free up some RAM
package 'spamassassin' do action :remove end
service 'spamassassin' do action [ :stop, :disable ] end

# Edit the clamd configuration file
# Set AllowSupplementaryGroups to TRUE
ruby_block "edit etc hosts" do
  block do
    rc = Chef::Util::FileEdit.new("/etc/clamav/clamd.conf")
    rc.search_file_replace_line(
      /^AllowSupplementaryGroups/,
      "AllowSupplementaryGroups true"
    )
    rc.write_file
  end
end

# start clamav
execute 'freshclam'
service 'clamav-daemon' do action :start end
