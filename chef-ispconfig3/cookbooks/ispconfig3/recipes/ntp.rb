#
# Cookbook Name:: ispconfig3
# Recipe:: ntp
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

# Install packages
%w{
    ntp
    ntpdate
}.each do |pkg|
  package pkg do
    action :install
  end
end
