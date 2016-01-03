#
# Cookbook Name:: ispconfig3
# Recipe:: fail2ban
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

package 'fail2ban' do
    action :install
end

template '/etc/fail2ban/jail.local' do
    source 'jail.local.erb'
end

template '/etc/fail2ban/filter.d/pureftpd.conf' do
    source 'pureftpd.conf.erb'
end

template '/etc/fail2ban/filter.d/dovecot-pop3imap.conf' do
    source 'dovecot-pop3imap.conf.erb'
end

execute 'echo "ignoreregex =" >> /etc/fail2ban/filter.d/postfix-sasl.conf'
service "fail2ban" do action :restart end
