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

service "fail2ban" do
  supports [ :status => true, :restart => true ]
  action [ :enable, :start ]
end

template '/etc/fail2ban/jail.local' do
    source 'jail.local.erb'
    owner 'root'
    group 'root'
    mode 0400
end

template '/etc/fail2ban/filter.d/pureftpd.conf' do
    source 'pureftpd.conf.erb'
end

template '/etc/fail2ban/filter.d/dovecot-pop3imap.conf' do
    s

template '/etc/fail2ban/filter.d/postfix-sasl.conf' do
    source 'postfix-sasl.conf.erb'
    notifies :restart, "service[fail2ban]"
end

# execute 'echo "ignoreregex =" >> /etc/fail2ban/filter.d/postfix-sasl.conf' do
#     notifies :restart, "service[fail2ban]"
# end

# service "fail2ban" do
#     action :restart
#     ignore_failure true
# end
