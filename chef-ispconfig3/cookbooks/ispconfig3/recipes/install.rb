#
# Cookbook Name:: ispconfig3
# Recipe:: install
#
# Copyright 2016, Daniel Fanica
#
# All rights reserved
#

# Download and extract ISPConfig 3 from the latest released version
tar_extract node['ispcongif']['install_file'] do
    target_dir '/tmp'
    creates node['ispcongif']['install_path']
    not_if { ::File.exists?("#{node['ispcongif']['install_path']}/install/install.php") }
end

template ::File.join(node['ispcongif']['install_path'], 'install', 'autoinstall.ini') do
    source 'autoinstall.ini.erb'
    variables(
        mysql_root_password: node['mysql']['root_password'],
        ispcongif_port: node['ispcongif']['port'],
        ssl_cert_country: node['ssl_cert']['country'],
        ssl_cert_state: node['ssl_cert']['state'],
        ssl_cert_locality: node['ssl_cert']['locality'],
        ssl_cert_organisation: node['ssl_cert']['organisation'],
        ssl_cert_organisation_unit: node['ssl_cert']['organisation_unit'],
        ssl_cert_common_name: node['ssl_cert']['common_name']
    )
end

# bash 'Installing ISPConfig3...' do
#     code <<-EOH
#         cd #{node['ispcongif']['install_path']}/install
#         php -q install.php --autoinstall=autoinstall.ini
#     EOH
#     not_if { ::File.exists?('/usr/local/ispconfig/server/server.php') }
# end

# bash 'Updating ISPConfig3...' do
#     code <<-EOH
#         cd #{node['ispcongif']['install_path']}/install
#         php -q update.php --autoinstall=autoinstall.ini
#     EOH
#     only_if { ::File.exists?('/usr/local/ispconfig/server/server.php') }
# end
