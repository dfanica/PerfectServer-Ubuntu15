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

unless exists?
    execute "newlist #{node['mailman']['list_name']}" do
        command "newlist -l en -q mailman #{node['mailman']['email']} #{node['mailman']['password']}"
    end
end

template '/etc/aliases' do
    source 'mailman_aliases.erb'
end

def exists?
  cmd = shell_out("list_lists")
  cmd.stdout.downcase.include?(node['mailman']['list_name'])
end
