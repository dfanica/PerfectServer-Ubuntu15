#
# Cookbook Name:: ispconfig3
# Recipe:: default
#
# Copyright 2016, Daniel Fanica
#
# All rights reserved
#

# download and decompress the files needed for the installation
bash 'ispconfig_setup-master' do
    code <<-EOH
        cd /tmp
        wget --no-check-certificate #{node['ispconfig']['zip_url']}
        unzip #{::File.basename(node['ispconfig']['zip_url'])}
    EOH
end
