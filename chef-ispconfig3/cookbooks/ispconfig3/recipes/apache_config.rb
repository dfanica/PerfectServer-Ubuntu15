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

# Remove `<FilesMatch "\.ph(p3?|tml)$">` section from suphp.conf
template '/etc/apache2/mods-available/suphp.conf' do
    source 'suphp.conf.erb'
    notifies :restart, 'service[apache2]'
end

# to host Ruby files with the extension .rb on the web sites created through ISPConfig,
# we must comment out the line `application/x-ruby rb` in /etc/mime.types
ruby_block "to enable ruby files on webserver" do
    block do
        rc = Chef::Util::FileEdit.new("/etc/mime.types")
        rc.search_file_replace_line(
            /^application\/x-ruby/,
            "# application/x-ruby rb"
        )
        rc.write_file
    end
end
