require_relative 'spec_helper'

['jenkins', 'clamav', 'openjdk-7-jdk', 'ruby', 'ruby-dev'].each do |value|
  describe package(value) do
    it { should be_installed }
  end
end

['brakeman', 'zapr', 'bundler-audit'].each do |value|
  describe package(value) do
    it { should be_installed.by('gem') }
  end
end

