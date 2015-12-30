#
# Cookbook Name:: ispconfig3
# Recipe:: default
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

# Edit /etc/apt/sources.list. Make sure that the universe and multiverse repositories are enabled.
template ::File.join(node['ispconfig3']['sources_list_path'], 'sources.list') do
    source 'sources.list.erb'
end
