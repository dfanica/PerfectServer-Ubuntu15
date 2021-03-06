#
# Author:: Daniel Lienert <daniel@lienert.cc>
# Copyright:: Copyright (c) 2013, Daniel Lienert
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

default['postfixgld']['mysql']['user'] = 'gld'
default['postfixgld']['mysql']['password'] = 'gld'
default['postfixgld']['mysql']['host'] = 'localhost'
default['postfixgld']['mysql']['db'] = 'gld'

default['postfixgld']['mxgrey'] = 0

# Postfix additional attributes
default['postfix']['smtpd_recipient_restrictions'] = ['check_policy_service inet:127.0.0.1:2525']