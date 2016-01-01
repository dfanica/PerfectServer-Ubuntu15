#
# Cookbook Name:: ispconfig3
# Recipe:: php
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

# Install packages
%w{
    libapache2-mod-php5
    php5-mcrypt
    php5-imap
    libapache2-mod-fcgid
    apache2-suexec
    php-auth
    mcrypt
    php5-imagick
    imagemagick
    libapache2-mod-suphp
    libruby
    libapache2-mod-python
    php5-intl
    php5-memcache
    php5-memcached
    php5-ming
    php5-ps
    php5-pspell
    php5-recode
    php5-tidy
    php5-xmlrpc
    php5-xsl
    memcached
}.each do |pkg|
  package pkg do
    action :install
  end
end
