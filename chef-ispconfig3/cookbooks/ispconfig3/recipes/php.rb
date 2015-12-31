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
    php5-gd
    php5-mcrypt
    php5-mysql
}.each do |pkg|
  package pkg do
    action :install
  end
end
