#
# Cookbook Name:: ispconfig3
# Recipe:: clamav
#
# Copyright 2015, Daniel Fanica
#
# All rights reserved
#

# Install packages
%w{
    amavisd-new
    spamassassin
    clamav
    clamav-daemon
    zoo
    unzip
    bzip2
    arj
    nomarch
    lzop
    cabextract
    apt-listchanges
    libnet-ldap-perl
    libauthen-sasl-perl
    clamav-docs
    daemon
    libio-string-perl
    libio-socket-ssl-perl
    libnet-ident-perl
    zip
    libnet-dns-perl
}.each do |pkg|
  package pkg do
    action :install
  end
end

# The ISPConfig 3 setup uses amavisd which loads the SpamAssassin filter library internally...
# so we can stop SpamAssassin to free up some RAM
service 'spamassassin' do action [ :stop, :disable ] end

# Edit the clamd configuration file
# Set AllowSupplementaryGroups to TRUE
ruby_block "edit etc hosts" do
  block do
    rc = Chef::Util::FileEdit.new("/etc/clamav/clamd.conf")
    rc.search_file_replace_line(
      /^AllowSupplementaryGroups /,
      "AllowSupplementaryGroups true"
    )
    rc.write_file
  end
end

# start clamav
execute 'freshclam'
service 'clamav-daemon' do action :start end
