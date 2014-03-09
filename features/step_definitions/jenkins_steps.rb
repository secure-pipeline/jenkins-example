When /^the client requests (.*)$/ do |domain|
  @last_response = HTTParty.get(domain)
end


Then /^the response should include "([^\"]*)"$/ do |response|
  @last_response.body.to_s.should match response
end
