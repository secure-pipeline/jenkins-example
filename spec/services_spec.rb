require_relative 'spec_helper'

['jenkins', 'clamav-daemon'].each do |value|
  describe service(value) do
    it { should be_enabled }
    it { should be_running }
  end
end
