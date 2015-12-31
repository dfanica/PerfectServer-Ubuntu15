#
# Cookbook Name:: ispconfig3
# Recipe:: phpmyadmin
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

require 'digest/sha1'

# remove any previous version of phpmyadmin
package 'phpmyadmin' do
    action :remove
end

home = node['phpmyadmin']['home']
user = node['phpmyadmin']['user']
group = node['phpmyadmin']['group']
conf = "#{home}/config.inc.php"
package_url = "#{node['phpmyadmin']['mirror']}/#{node['phpmyadmin']['version']}/phpMyAdmin-#{node['phpmyadmin']['version']}-all-languages.tar.gz"

group group do
    action [ :create, :manage ]
end

user user do
    action [ :create, :manage ]
    comment 'PHPMyAdmin User'
    gid group
    home home
    shell '/usr/sbin/nologin'
    supports :manage_home => true
end

directory home do
    owner user
    group group
    mode 00755
    recursive true
    action :create
end

directory node['phpmyadmin']['upload_dir'] do
    owner 'root'
    group 'root'
    mode 01777
    recursive true
    action :create
end

directory node['phpmyadmin']['save_dir'] do
    owner 'root'
    group 'root'
    mode 01777
    recursive true
    action :create
end

# Download the selected PHPMyAdmin archive
phpmyadmin_file = ::File.join(Chef::Config[:file_cache_path], ::File.basename(package_url))
remote_file phpmyadmin_file do
    owner user
    group group
    mode 00644
    action :create_if_missing
    source package_url
    checksum node['phpmyadmin']['checksum']
end

bash 'extract-php-myadmin' do
    user user
    group group
    cwd home
    code <<-EOH
        rm -fr *
        tar xzf #{phpmyadmin_file}
        mv phpMyAdmin-#{node['phpmyadmin']['version']}-all-languages/* #{home}/
        rm -fr phpMyAdmin-#{node['phpmyadmin']['version']}-all-languages
    EOH
    not_if { ::File.exists?("#{home}/RELEASE-DATE-#{node['phpmyadmin']['version']}")}
end

# tar_extract package_url do
#   target_dir "#{home}/phpMyAdmin-#{node['phpmyadmin']['version']}-all-languages"
#   creates "#{home}/phpMyAdmin-#{node['phpmyadmin']['version']}-all-languages"
#   not_if { ::File.exists?("#{home}/RELEASE-DATE-#{node['phpmyadmin']['version']}")}
# end

directory "#{home}/conf.d" do
    owner user
    group group
    mode 00755
    recursive true
    action :create
end

template "#{home}/config.inc.php" do
    source 'config.inc.php.erb'
    owner user
    group group
    mode 00644
end
