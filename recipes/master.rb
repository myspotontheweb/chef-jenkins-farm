#
# Cookbook Name:: jenkins-farm
# Recipe:: master
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe "apt"
include_recipe "java"
include_recipe "jenkins::master"

# Generate a SSH keypair
pubkey  = "#{node['jenkins']['master']['home']}/.ssh/id_rsa.pub"
privkey = "#{node['jenkins']['master']['home']}/.ssh/id_rsa"

execute "generate ssh keys for jenkins" do
  user  node['jenkins']['master']['user']
  group node['jenkins']['master']['group']
  creates pubkey
  command "ssh-keygen -t rsa -q -f #{privkey} -P \"\""
end

# Save public key to chef-server 
ruby_block 'node-save-pubkey' do
  block do
    node.set_unless['jenkins-farm']['public_key'] = File.read(pubkey)
    node.save unless Chef::Config['solo']
  end
end

# Set tag so that slaves can find this node
tag('jenkins_master')

