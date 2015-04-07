require 'spec_helper'

describe package('jenkins') do
  it { should be_installed }
end

describe port('8080') do
  it { should be_listening }
end

describe user('jenkins') do
  it { should exist }
  it { should belong_to_group 'jenkins' }
  it { should have_home_directory '/var/lib/jenkins' }
end

describe file('/var/lib/jenkins') do
  it { should be_directory }
end

describe file('/var/lib/jenkins/.ssh') do
  it { should be_directory }
  it { should be_owned_by 'jenkins' }
  it { should be_grouped_into 'jenkins' }
  it { should be_mode '700' }
end

describe file('/var/lib/jenkins/.ssh/id_rsa') do
  it { should be_file }
  it { should be_owned_by 'jenkins' }
  it { should be_grouped_into 'jenkins' }
  it { should be_mode '600' }
end

describe process('java') do
  it { should be_running } 
  #its('args') { should match(/-XX:MaxPermSize=512m/) }
  its('args') { should match(/-jar \/usr\/(share|lib)\/jenkins\/jenkins.war/) }
  its('args') { should match(/--httpPort=8080/) }
  its('args') { should match(/--httpListenAddress=0.0.0.0/) }
end

