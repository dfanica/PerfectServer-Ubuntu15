#
# Cookbook Name:: ispconfig3
# Recipe:: mailman
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

package 'mailman' do
    action :install
end

# Before we can start Mailman, a first mailing list called mailman must be created
ispconfig3_mailman_list node['mailman']['list_name'] do
    email node['mailman']['email']
    password node['mailman']['password']
    action :create
end

# Start the Mailman daemon
service 'mailman' do
    action [:enable, :start]
end

template '/etc/aliases' do
    source 'aliases.erb'
end

execute 'newaliases' do
    notifies :restart, 'service[postfix]'
end

# enable the Mailman Apache configuration
link '/etc/apache2/conf-available/mailman.conf' do
    to '/etc/mailman/apache.conf'
    link_type :symbolic
    notifies :restart, 'service[apache2]'
    notifies :restart, 'service[mailman]'
end
