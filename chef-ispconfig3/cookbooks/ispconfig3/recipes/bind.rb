#
# Cookbook Name:: ispconfig3
# Recipe:: bind
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

# Install BIND DNS Server
# Install Vlogger, Webalizer, And AWstats
# Install Jailkit
%w{
    bind9
    dnsutils
    vlogger
    webalizer
    awstats
    geoip-database
    libclass-dbi-mysql-perl
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

file '/etc/cron.d/awstats' do content '' end

# Jailkit is needed only if you want to chroot SSH users
# http://olivier.sessink.nl/jailkit/jailkit-2.17.tar.gz
tar_package 'http://olivier.sessink.nl/jailkit/jailkit-2.17.tar.gz' do
    prefix '/tmp'
    creates '/tmp/jailkit'
end
