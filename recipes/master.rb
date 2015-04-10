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

# create SSH credential
jenkins_private_key_credentials node['jenkins']['master']['user'] do
  username node['jenkins']['master']['user']
  description 'Jenkins Slave SSH Key'
  private_key lazy { File.read(privkey) }
end

# Create slave nodes
search(:node,
       "tags:jenkins_slave AND chef_environment:#{node.chef_environment}",
       :filter_result => {
         'name' => ['name'],
         'address' => ['fqdn'] }).each do |slave|

  jenkins_ssh_slave slave['name'] do
    description 'Run builds as slaves'
    remote_fs   '/var/lib/jenkins'
    labels      ['executor']
    executors   2

    # SSH specific attributes
    host        slave['address'] 
    user        node['jenkins']['master']['user']
    credentials node['jenkins']['master']['user']
  end

end

# Save public key
ruby_block 'node-save-public-key' do
  block do
    node.set_unless['jenkins-farm']['public_key'] = File.read(pubkey)
    node.save unless Chef::Config['solo']
  end
end

# Set tag so that slaves can find this node
tag('jenkins_master')

