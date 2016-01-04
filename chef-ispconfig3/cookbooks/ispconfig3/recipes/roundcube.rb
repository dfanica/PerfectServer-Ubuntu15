#
# Cookbook Name:: ispconfig3
# Recipe:: roundcube
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

# Install packages
%w{
    roundcube
    roundcube-core
    roundcube-mysql
    roundcube-plugins
    roundcube-plugins-extra
    javascript-common
    libjs-jquery-mousewheel
    php-net-sieve tinymce
}.each do |pkg|
    package pkg do
        action :install
    end
end
