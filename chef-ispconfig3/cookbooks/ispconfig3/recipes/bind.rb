#
# Cookbook Name:: ispconfig3
# Recipe:: bind
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

# Install packages
%w{
    bind9
    dnsutils
}.each do |pkg|
  package pkg do
    action :install
  end
end
