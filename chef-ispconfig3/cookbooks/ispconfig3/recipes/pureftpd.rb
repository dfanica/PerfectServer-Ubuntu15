#
# Cookbook Name:: ispconfig3
# Recipe:: pureftpd
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

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
        rc.search_file_replace_line(/^STANDALONE_OR_INETD/, "STANDALONE_OR_INETD=standalone")
        rc.search_file_replace_line(/^VIRTUALCHROOT/, "VIRTUALCHROOT=true")
        rc.write_file
    end
end

# to allow FTP and TLS sessions
execute 'echo 1 > /etc/pure-ftpd/conf/TLS'

# In order to use TLS, we must create an SSL certificate.
# Create it in /etc/ssl/private/, therefore create the directory first
directory '/etc/ssl/private/' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
end

# include_recipe 'openssl'

# openssl req -x509 -nodes -days 7300 -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem
# openssl_rsa_key '/etc/ssl/private/pure-ftpd.pem' do
#   key_length 2048
# end
