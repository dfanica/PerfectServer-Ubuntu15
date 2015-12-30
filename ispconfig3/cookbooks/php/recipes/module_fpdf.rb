#
# Author::  Joshua Timberman (<joshua@getchef.com>)
# Author::  Seth Chisamore (<schisamo@getchef.com>)
# Cookbook Name:: php
# Recipe:: module_fpdf
#
# Copyright 2009-2014, Chef Software, Inc.
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
# limitations under the License.
#

case node['platform_family']
when 'rhel', 'fedora'
  pearhub_chan = php_pear_channel 'pearhub.org' do
    action :discover
  end
  php_pear 'FPDF' do
    channel pearhub_chan.channel_name
    action :install
  end
when 'debian'
  package 'php-fpdf' do
    action :install
  end
end
