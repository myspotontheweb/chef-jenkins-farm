require 'spec_helper'

describe port(22) do
  it { should be_listening }
end

describe user('jenkins') do
  it { should exist }
  it { should belong_to_group 'jenkins' }
  it { should have_home_directory '/var/lib/jenkins' }
  it { should have_authorized_key 'xyz123' }
  it { should have_authorized_key 'abc123' }
end

