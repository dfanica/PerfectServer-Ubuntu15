#
# Cookbook Name:: ispconfig3
# Recipe:: default
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

# update the system
# include_recipe "apt"
execute 'apt-get update'
execute 'apt-get upgrade' do
    command 'apt-get upgrade -y'
    ignore_failure true
    action :run
end

# /bin/sh is a symlink to /bin/dash, however we need /bin/bash, not /bin/dash.'
link '/bin/sh' do
  to 'bash'
  link_type :symbolic
end
