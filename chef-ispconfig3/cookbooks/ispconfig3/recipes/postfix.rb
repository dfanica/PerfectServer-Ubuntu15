#
# Cookbook Name:: ispconfig3
# Recipe:: postfix
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

bash 'Installing Postfix...' do
    code <<-EOH
        echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
        echo "postfix postfix/mailname string mail.danielfanica.com | debconf-set-selections
        apt-get -yqq install postfix postfix-mysql postfix-doc getmail4 > /dev/null 2>&1
    EOH
end

# Open the TLS/SSL and submission ports in Postfix
template '/etc/postfix/master.cf' do
    source 'master.cf.erb'
    notifies :restart, 'service[postfix]'
end
