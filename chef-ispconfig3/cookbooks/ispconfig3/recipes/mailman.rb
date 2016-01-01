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

unless shell_out('list_lists').stdout.downcase.include?(node['mailman']['list_name'])
    execute "newlist #{node['mailman']['list_name']}" do
        command "newlist -l en -q mailman #{node['mailman']['email']} #{node['mailman']['password']}"
    end
end

template '/etc/aliases' do
    source 'aliases.erb'
end
