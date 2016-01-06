#
# Cookbook Name:: ispconfig3
# Recipe:: install
#
# Copyright 2016, Daniel Fanica
#
# All rights reserved
#

# Download and extract ISPConfig 3 from the latest released version
tar_extract node['ispcongif']['install_file'] do
    target_dir '/tmp'
    creates node['ispcongif']['install_path']
    not_if { ::File.exists?("#{node['ispcongif']['install_path']}/install/install.php") }
end

autoinstall = "#{node['ispcongif']['install_path']}/install/autoinstall.ini"
bash 'generate ISPConfig configuration file' do
    code <<-EOH
        touch #{autoinstall}
        echo "[install]" >> #{autoinstall}
        echo "language=en" >> #{autoinstall}
        echo "install_mode=standard" >> #{autoinstall}
        echo "hostname=danielfanica.com" >> #{autoinstall}
        echo "mysql_hostname=localhost" >> #{autoinstall}
        echo "mysql_root_user=root" >> #{autoinstall}
        echo "mysql_root_password=#{node['mysql']['root_password']}" >> #{autoinstall}
        echo "mysql_database=dbispconfig" >> #{autoinstall}
        echo "mysql_charset=utf8" >> #{autoinstall}
        echo "http_server=apache" >> #{autoinstall}
        echo "ispconfig_port=8080" >> #{autoinstall}
        echo "ispconfig_use_ssl=y" >> #{autoinstall}
        echo "[ssl_cert]" >> #{autoinstall}
        echo "ssl_cert_country=IE" >> #{autoinstall}
        echo "ssl_cert_state=Ireland" >> #{autoinstall}
        echo "ssl_cert_locality=Dublin" >> #{autoinstall}
        echo "ssl_cert_organisation=WyGom" >> #{autoinstall}
        echo "ssl_cert_organisation_unit=IT department" >> #{autoinstall}
        echo "ssl_cert_common_name=danielfanica.com" >> #{autoinstall}
        echo "[expert]" >> #{autoinstall}
        echo "mysql_ispconfig_user=ispconfig" >> #{autoinstall}
        echo "mysql_ispconfig_password=afStEratXBsgatRtsa42CadwhQ" >> #{autoinstall}
        echo "join_multiserver_setup=n" >> #{autoinstall}
        echo "mysql_master_hostname=master.example.com" >> #{autoinstall}
        echo "mysql_master_root_user=root" >> #{autoinstall}
        echo "mysql_master_root_password=ispconfig" >> #{autoinstall}
        echo "mysql_master_database=dbispconfig" >> #{autoinstall}
        echo "configure_mail=y" >> #{autoinstall}
        echo "configure_jailkit=$CFG_JKIT" >> #{autoinstall}
        echo "configure_ftp=y" >> #{autoinstall}
        echo "configure_dns=y" >> #{autoinstall}
        echo "configure_apache=y" >> #{autoinstall}
        echo "configure_nginx=n" >> #{autoinstall}
        echo "configure_firewall=y" >> #{autoinstall}
        echo "install_ispconfig_web_interface=y" >> #{autoinstall}
        echo "[update]" >> #{autoinstall}
        echo "do_backup=yes" >> #{autoinstall}
        echo "mysql_root_password=#{node['mysql']['root_password']}" >> #{autoinstall}
        echo "mysql_master_hostname=master.example.com" >> #{autoinstall}
        echo "mysql_master_root_user=root" >> #{autoinstall}
        echo "mysql_master_root_password=ispconfig" >> #{autoinstall}
        echo "mysql_master_database=dbispconfig" >> #{autoinstall}
        echo "reconfigure_permissions_in_master_database=no" >> #{autoinstall}
        echo "reconfigure_services=yes" >> #{autoinstall}
        echo "ispconfig_port=8080" >> #{autoinstall}
        echo "create_new_ispconfig_ssl_cert=no" >> #{autoinstall}
        echo "reconfigure_crontab=yes" >> #{autoinstall}
    EOH
    not_if { ::File.exists?(autoinstall) }
end

# bash 'Installing ISPConfig3...' do
#     code <<-EOH
#         cd #{node['ispcongif']['install_path']}/install
#         php -q install.php --autoinstall=autoinstall.ini
#     EOH
#     not_if { ::File.exists?('/usr/local/ispconfig/server/server.php') }
# end

# bash 'Updating ISPConfig3...' do
#     code <<-EOH
#         cd #{node['ispcongif']['install_path']}/install
#         php -q update.php --autoinstall=autoinstall.ini
#     EOH
#     only_if { ::File.exists?('/usr/local/ispconfig/server/server.php') }
# end
