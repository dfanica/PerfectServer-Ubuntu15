#
# Cookbook Name:: ispconfig3
# Recipe:: default
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

package 'mailman' do
    action :install
end

execute "newlist mailman" do
    command "newlist -q mailman #{node['mailman']['email']} #{node['mailman']['password']}"
end

template '/etc/aliases' do
    source 'mailman_aliases.erb'
end
