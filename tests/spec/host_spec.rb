require_relative 'spec_helper'

describe command('hostname') do
  it { should return_stdout 'jenkins.local' }
end

describe command('hostname -d') do
  it { should return_stdout 'local' }
end
