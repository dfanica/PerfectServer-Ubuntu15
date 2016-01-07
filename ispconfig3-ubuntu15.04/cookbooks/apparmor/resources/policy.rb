#
# Cookbook Name:: apparmor
# Resource:: policy
#
# Copyright 2015, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
#

property :name, String, name_attribute: true
property :source_cookbook, String
property :source_filename, String

action :add do
  cookbook_file "/etc/apparmor.d/#{name}" do
    cookbook source_cookbook if source_cookbook
    source source_filename if source_filename
    owner 'root'
    group 'root'
    mode '0644'
    notifies :reload, 'service[apparmor]', :immediately
  end

  service 'apparmor' do
    supports status: true, restart: true, reload: true
    action [:nothing]
  end
end

action :remove do
  file "/etc/apparmor.d/#{name}" do
    action :delete
    notifies :reload, 'service[apparmor]', :immediately
  end

  service 'apparmor' do
    supports status: true, restart: true, reload: true
    action [:nothing]
  end
end
