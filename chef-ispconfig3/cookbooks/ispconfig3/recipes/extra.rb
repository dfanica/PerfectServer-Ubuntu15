#
# Cookbook Name:: ispconfig3
# Recipe:: extra
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

# Install packages
%w{
    apache2-doc
}.each do |pkg|
  package pkg do
    action :install
  end
end

# Disable AppArmor
include_recipe 'apparmor'
