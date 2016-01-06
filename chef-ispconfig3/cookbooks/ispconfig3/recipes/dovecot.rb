#
# Cookbook Name:: ispconfig3
# Recipe:: dovecot
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

# Install packages
%w{
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
