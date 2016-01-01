#
# Cookbook Name:: ispconfig3
# Recipe:: default
#
# Copyright 2015, Daniel Fanica
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

# /bin/sh is a symlink to /bin/dash, however we need /bin/bash, not /bin/dash
link '/bin/sh' do
  to 'bash'
  link_type :symbolic
end

# Synchronize the System Clock
include_recipe 'ntp'

# Disable AppArmor
include_recipe 'apparmor'
