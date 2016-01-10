#
# Author:: Daniel Fanica <contact@danielfanica.com>
# Copyright:: Copyright (c) 2015, Daniel Fanica
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name             'ispconfig3'
maintainer       'Daniel Daniel'
maintainer_email 'contact@danielfanica'
license          'All rights reserved'
description      'Installs/Configures server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends          'apt'
depends          'build-essential'
depends          'dmg'
depends          'magic_shell'
depends          'hostupgrade'
depends          'apparmor'
depends          'sendmail'
depends          'git'
depends          'zip'
depends          'tar'
