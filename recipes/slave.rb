#
# Cookbook Name:: jenkins-farm
# Recipe:: slave
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

# Create jenkins user
user node['jenkins']['master']['user'] do
  home node['jenkins']['master']['home']
  shell '/bin/bash'
end

# Create Jenkins group
group node['jenkins']['master']['user'] 

# Create .ssh directory for jenkins
directory "#{node['jenkins']['master']['home']}/.ssh" do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  mode 0700
  recursive true
end

# Create the authorized_keys file
template "#{node['jenkins']['master']['home']}/.ssh/authorized_keys" do
  owner node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  variables(
    ssh_keys: search(:node, "tags:jenkins_master AND chef_environment:#{node.chef_environment}", :filter_result => {'public_part' => ['jenkins-farm','public_key']})
  )
  mode 00644
  action :create # create every time. master key could change.
end

# Set tag so that master can find this node
tag('jenkins_slave')

