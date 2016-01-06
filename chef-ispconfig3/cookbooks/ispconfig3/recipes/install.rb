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

bash 'installing ISPConfig3...' do
    code <<-EOH
        touch #{node['ispcongif']['install_path']}/autoinstall.ini
        echo "[install]" > autoinstall.ini
        echo "language=en" >> autoinstall.ini
        echo "install_mode=standard" >> autoinstall.ini
        echo "hostname=danielfanica.com" >> autoinstall.ini
        echo "mysql_hostname=localhost" >> autoinstall.ini
        echo "mysql_root_user=root" >> autoinstall.ini
        echo "mysql_root_password=#{node['mysql']['root_password']}" >> autoinstall.ini
        echo "mysql_database=dbispconfig" >> autoinstall.ini
        echo "mysql_charset=utf8" >> autoinstall.ini
        echo "http_server=apache" >> autoinstall.ini
        echo "ispconfig_port=8080" >> autoinstall.ini
        echo "ispconfig_use_ssl=y" >> autoinstall.ini
        echo
        echo "[ssl_cert]" >> autoinstall.ini
        echo "ssl_cert_country=IE" >> autoinstall.ini
        echo "ssl_cert_state=Ireland" >> autoinstall.ini
        echo "ssl_cert_locality=Dublin" >> autoinstall.ini
        echo "ssl_cert_organisation=WyGom" >> autoinstall.ini
        echo "ssl_cert_organisation_unit=IT department" >> autoinstall.ini
        echo "ssl_cert_common_name=danielfanica.com" >> autoinstall.ini
        echo
        echo "[expert]" >> autoinstall.ini
        echo "mysql_ispconfig_user=ispconfig" >> autoinstall.ini
        echo "mysql_ispconfig_password=afStEratXBsgatRtsa42CadwhQ" >> autoinstall.ini
        echo "join_multiserver_setup=n" >> autoinstall.ini
        echo "mysql_master_hostname=master.example.com" >> autoinstall.ini
        echo "mysql_master_root_user=root" >> autoinstall.ini
        echo "mysql_master_root_password=ispconfig" >> autoinstall.ini
        echo "mysql_master_database=dbispconfig" >> autoinstall.ini
        echo "configure_mail=y" >> autoinstall.ini
        echo "configure_jailkit=$CFG_JKIT" >> autoinstall.ini
        echo "configure_ftp=y" >> autoinstall.ini
        echo "configure_dns=y" >> autoinstall.ini
        echo "configure_apache=y" >> autoinstall.ini
        echo "configure_nginx=n" >> autoinstall.ini
        echo "configure_firewall=y" >> autoinstall.ini
        echo "install_ispconfig_web_interface=y" >> autoinstall.ini
        echo
        echo "[update]" >> autoinstall.ini
        echo "do_backup=yes" >> autoinstall.ini
        echo "mysql_root_password=#{node['mysql']['root_password']}" >> autoinstall.ini
        echo "mysql_master_hostname=master.example.com" >> autoinstall.ini
        echo "mysql_master_root_user=root" >> autoinstall.ini
        echo "mysql_master_root_password=ispconfig" >> autoinstall.ini
        echo "mysql_master_database=dbispconfig" >> autoinstall.ini
        echo "reconfigure_permissions_in_master_database=no" >> autoinstall.ini
        echo "reconfigure_services=yes" >> autoinstall.ini
        echo "ispconfig_port=8080" >> autoinstall.ini
        echo "create_new_ispconfig_ssl_cert=no" >> autoinstall.ini
        echo "reconfigure_crontab=yes" >> autoinstall.ini
    EOH
    not_if { ::File.exists?("#{node['ispcongif']['install_path']}/autoinstall.ini") }
end

#php -q install.php --autoinstall=autoinstall.ini
