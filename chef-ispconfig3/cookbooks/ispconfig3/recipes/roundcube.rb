#
# Cookbook Name:: ispconfig3
# Recipe:: roundcube
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

# Configure database for roundcube with dbconfig-common? <-- Yes
# Database type to be used by roundcube: <-- mysql
# Password of the database's administrative user: <-- Enter your mysql root password here
# MySQL application password for roundcube: <-- Press enter
bash 'installing roundcube...' do
    code <<-EOH
        echo "roundcube-core roundcube/dbconfig-install boolean true" | debconf-set-selections
        echo "roundcube-core roundcube/database-type select mysql" | debconf-set-selections
        echo "roundcube-core roundcube/mysql/admin-pass password #{node['mysql']['root_password']}" | debconf-set-selections
        echo "roundcube-core roundcube/db/dbname string roundcube" | debconf-set-selections
        echo "roundcube-core roundcube/mysql/app-pass password " | debconf-set-selections
        echo "roundcube-core roundcube/app-password-confirm password " | debconf-set-selections
        apt-get -y install roundcube roundcube-mysql git > /dev/null 2>&1
    EOH
    not_if { ::File.exists?('/etc/roundcube/apache.conf') }
end

# Install packages
%w{
    roundcube-plugins
    roundcube-plugins-extra
    javascript-common
    libjs-jquery-mousewheel
    php-net-sieve
    tinymce
}.each do |pkg|
    package pkg do
        action :install
    end
end

# prevent Roundcube from showing a server name input field in the login form
ruby_block "remove commented lines from roundcube.conf" do
    block do
        rc = Chef::Util::FileEdit.new("/etc/apache2/conf-enabled/roundcube.conf")
        rc.search_file_replace_line(/^(#|Alias\s).+?$\r\n/, "")
        rc.write_file
    end
end
# execute "sed -i '1iAlias /roundcube/program/js/tiny_mce/ /usr/share/tinymce/www/' /etc/apache2/conf-enabled/roundcube.conf"
# execute "sed -i '1iAlias /roundcube /var/lib/roundcube' /etc/apache2/conf-enabled/roundcube.conf"
# execute "sed -i '1iAlias /webmail/program/js/tiny_mce/ /usr/share/tinymce/www/' /etc/apache2/conf-enabled/roundcube.conf"
# execute "sed -i '1iAlias /webmail /var/lib/roundcube' /etc/apache2/conf-enabled/roundcube.conf"
[
    'Alias /roundcube/program/js/tiny_mce/ /usr/share/tinymce/www/',
    'Alias /roundcube /var/lib/roundcube',
    'Alias /webmail/program/js/tiny_mce/ /usr/share/tinymce/www/',
    'Alias /webmail /var/lib/roundcube'
].each do |als|
    execute "sed -i '1i#{als}' /etc/apache2/conf-enabled/roundcube.conf"
end

# template '/etc/apache2/conf-enabled/roundcube.conf' do
#     source 'roundcube.conf.erb'
#     notifies :restart, 'service[apache2]'
# end

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
