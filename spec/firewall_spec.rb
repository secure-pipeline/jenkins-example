require_relative 'spec_helper'

describe package('ufw') do
  it { should be_installed }
end

describe service('ufw') do
  it { should be_enabled }
  it { should be_running }
end

[22, 9090, 3310].each do |value|
  describe port(value) do
    it { should be_listening }
  end
end

describe host('example.com') do
  it { should be_resolvable }
  it { should be_reachable }
end
