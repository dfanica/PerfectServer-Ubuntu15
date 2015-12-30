#
# Cookbook Name:: ispconfig3
# Recipe:: default
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

# Edit /etc/apt/sources.list. Make sure that the universe and multiverse repositories are enabled.
template ::File.join(node['ispconfig3']['sources_list_path'], 'sources.list') do
    source 'sources.list.erb'
end

# update the system
# include_recipe "apt"
execute 'apt-get update && upgrade' do
    command 'apt-get update && apt-get upgrade -y'
    action :run
end

# /bin/sh is a symlink to /bin/dash, however we need /bin/bash, not /bin/dash.'
link '/bin/sh' do
  to 'bash'
  link_type :symbolic
end

bash 'Disable AppArmor' do
    code <<-END
        service apparmor stop
        update-rc.d -f apparmor remove
    END
end
dpkg_package "apparmor" do action :remove end
dpkg_package "apparmor-utils" do action :remove end

execute 'Stop and remove sendmail' do
    command 'service sendmail stop; update-rc.d -f sendmail remove'
    action :nothing
end

# Install packages
%w{
    ntp
    ntpdate
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
