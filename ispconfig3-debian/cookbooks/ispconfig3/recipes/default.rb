#
# Cookbook Name:: ispconfig3
# Recipe:: default
#
# Copyright 2016, Daniel Fanica
#
# All rights reserved
#

# Edit /etc/apt/sources.list. Make sure that the universe and multiverse repositories are enabled.
template '/etc/apt/sources.list' do
    source 'sources.list.erb'
end

# update the system
# include_recipe "apt"
execute 'apt-get update'
include_recipe 'hostupgrade::upgrade'

# download and decompress the files needed for the installation
bash 'ispconfig_setup-master' do
    code <<-EOH
        cd /tmp
        wget --no-check-certificate #{node['ispconfig']['zip_url']}
        unzip #{::File.basename(node['ispconfig']['zip_url'])}
    EOH
end
