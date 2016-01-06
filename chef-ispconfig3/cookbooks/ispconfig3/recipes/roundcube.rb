#
# Cookbook Name:: ispconfig3
# Recipe:: roundcube
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#
bash 'installing roundcube...' do
    code <<-EOH
        RANDPWD=`date +%N%s | md5sum`
        echo "roundcube-core roundcube/dbconfig-install boolean true" | debconf-set-selections
        echo "roundcube-core roundcube/database-type select mysql" | debconf-set-selections
        echo "roundcube-core roundcube/mysql/admin-pass password #{node['mysql']['root_password']}" | debconf-set-selections
        echo "roundcube-core roundcube/db/dbname string roundcube" | debconf-set-selections
        echo "roundcube-core roundcube/mysql/app-pass password password" | debconf-set-selections
        echo "roundcube-core roundcube/app-password-confirm password password" | debconf-set-selections
        apt-get -y install roundcube roundcube-mysql git > /dev/null 2>&1
    EOH
end

# Install packages
%w{
    roundcube-plugins
    roundcube-plugins-extra
    javascript-common
    libjs-jquery-mousewheel
    php-net-sieve tinymce
}.each do |pkg|
    package pkg do
        action :install
    end
end

template '/etc/apache2/conf-enabled/roundcube.conf' do
    source 'roundcube.conf.erb'
    notifies :restart, 'service[apache2]'
end

# prevent Roundcube from showing a server name input field in the login form
ruby_block "change the default host to localhost" do
    block do
        rc = Chef::Util::FileEdit.new("/etc/roundcube/main.inc.php")
        rc.search_file_replace_line(
            /^$rcmail_config['default_host'] = /,
            "$rcmail_config['default_host'] = 'localhost';"
        )
        rc.write_file
    end
end
