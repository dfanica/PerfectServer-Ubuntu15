#
# Cookbook Name:: ispconfig3
# Recipe:: php
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

# Enable the Apache modules suexec, rewrite, ssl, actions
execute 'apache: enable modules suexec, rewrite, ssl, actions' do
    command 'a2enmod suexec rewrite ssl actions include cgi'
    ignore_failure true
end

# ...and include (plus dav, dav_fs, and auth_digest if you want to use WebDAV)
execute 'apache: enable modules dav, dav_fs, auth_digest' do
    command 'a2enmod dav_fs dav auth_digest'
    ignore_failure true
end

# And enable the mcrypt module in PHP
execute 'php: enable mcrypt module' do
    command 'php5enmod mcrypt'
    ignore_failure true
end
