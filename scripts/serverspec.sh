#!/bin/bash
gem install bundler --no-ri --no-rdoc
cd /tmp/tests
bundle install --path=vendor
SERVERSPEC_LOCAL=true bundle exec rake spec
