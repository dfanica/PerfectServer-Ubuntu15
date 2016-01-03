#
# Cookbook Name:: ispconfig3
# Recipe:: mailman
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

include Chef::Mixin::ShellOut

package 'mailman' do
    action :install
end

# Start the Mailman daemon
service 'mailman' do
    action [:enable, :start]
end

# def list_name_exists?
#     mailman_lists = `list_lists`
#     Chef::Log.info("Mailman existing lists: #{mailman_lists.chomp}")
#     $?.success?
# end

# module MyServiceChecker
#     def my_service_running?
#         cmd = Mixlib::ShellOut.new('/etc/init.d/mailman status')
#         cmd.run_command
#         cmd.exitstatus == 0
#     end
# end

# Chef::Recipe.send(:include, MyServiceChecker)
# Chef::Resource.send(:include, MyServiceChecker)
# Chef::Provider.send(:include, MyServiceChecker)

# Before we can start Mailman, a first mailing list called mailman must be created
unless File.exist?('/etc/mailman/apache.conf')
    unless shell_out('list_lists').stdout.downcase.include?(node['mailman']['list_name'])
    # unless list_name_exists?
        execute "newlist #{node['mailman']['list_name']}" do
            command "newlist -l en -q mailman #{node['mailman']['email']} #{node['mailman']['password']}"
        end
    end
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
