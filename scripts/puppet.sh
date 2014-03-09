#!/bin/bash

red='\e[0;31m'
orange='\e[0;33m'
green='\e[0;32m'
end='\e[0m'

# if puppet is already installed do nothing
if which /usr/local/bin/puppet > /dev/null 2>&1; then
  echo -e "${orange}----> Puppet is aready installed${end}"
  exit 0
fi

# Install language locale as without can 
# interfere with package installation
sudo apt-get install language-pack-en -y

# Install Ruby
echo -e "----> ${green}Installing ruby${end}"
sudo apt-get update
sudo apt-get install ruby ruby-dev -y

# Install puppet/facter
echo -e "----> ${green}Installing puppet${end}"
sudo gem install puppet facter --no-ri --no-rdoc
