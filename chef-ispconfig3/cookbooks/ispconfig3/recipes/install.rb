#
# Cookbook Name:: ispconfig3
# Recipe:: install
#
# Copyright 2016, Daniel Fanica
#
# All rights reserved
#

# Download the selected PHPMyAdmin archive
tar_extract 'http://www.ispconfig.org/downloads/ISPConfig-3-stable.tar.gz' do
    target_dir '/tmp'
    creates '/tmp/ispconfig3_install'
    not_if { ::File.exists?('/tmp/ispconfig3_install/install/install.php') }
end
