[![Build Status](https://travis-ci.org/computerlyrik/chef-mailman.png?branch=mas
ter)](https://travis-ci.org/computerlyrik/chef-mailman)

Description
===========

Code repo: https://github.com/computerlyrik/chef-mailman

Requirements
============

Attributes
==========

see attributes.rb for possible attributes
site_pass and list_creator only will be set if defined externally

Usage
=====

mailman_list "mylist1" do
  email "owner@example.com"
end

mailman_list "mylist2" do
  email "owner@example.com"
  password "my_non_random_password"
end

mailman_list "mylist3" do
  action :delete
end
