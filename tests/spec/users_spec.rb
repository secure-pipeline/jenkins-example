require_relative 'spec_helper'

describe user('jenkins') do
  it { should exist }
  it { should belong_to_group 'jenkins' }
end

describe user('root') do
  it { should exist }
end

describe user('garethr') do
  it { should exist }
  it { should belong_to_group 'garethr' }
  it { should belong_to_group 'sudo' }
end
