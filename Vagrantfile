# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = {
  'jenkins.local' => {:virtualbox_ip => '192.168.90.30', :virtualbox_memory => 1536, :digitalocean_memory => '1GB'},
}
node_defaults = {
  :virtualbox_memory => 256,
  :digitalocean_image  => 'Ubuntu 14.04 x64',
  :digitalocean_region => 'Amsterdam 1',
  :digitalocean_memory => '512MB',
}

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.vm.provision :shell, :path => 'scripts/puppet.sh'
  config.vm.provision :puppet do |puppet|
    puppet.options        = '--debug --verbose --summarize --reports store --hiera_config=/vagrant/hiera.yaml'
    puppet.manifests_path = 'manifests'
    puppet.module_path    = [ 'modules', 'vendor/modules' ]
    puppet.manifest_file  = 'base.pp'
  end

  config.ssh.private_key_path = '~/.ssh/id_rsa'

  config.vm.provision :serverspec do |spec|
    spec.pattern = 'tests/spec/*_spec.rb'
  end

  nodes.each_with_index do |(node_name, node_opts), i|
    config.vm.define node_name do |node|
      node_opts         = node_defaults.merge(node_opts)
      node.vm.hostname  = node_name

      config.vm.provider :digital_ocean do |provider, override|
        override.vm.box = 'digital_ocean'
        override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"

        provider.client_id = ENV['DIGITAL_OCEAN_CLIENT_ID']
        provider.api_key = ENV['DIGITAL_OCEAN_API_KEY']
        provider.image = node_opts[:digitalocean_image]
        provider.region = node_opts[:digitalocean_region]
        provider.size = node_opts[:digitalocean_memory]
      end

      node.vm.provider :virtualbox do |provider, override|
        provider.memory = node_opts[:virtualbox_memory]
        override.vm.network :private_network, ip: node_opts[:virtualbox_ip]
        override.vm.provision :cucumber
      end
    end
  end

end
