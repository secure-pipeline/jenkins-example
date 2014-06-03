# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = {
  'jenkins' => {:ip => '192.168.90.30', :memory => 2048},
}
node_defaults = {
  :memory => 256,
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

  config.vm.provision :serverspec do |spec|
    spec.pattern = 'spec/*_spec.rb'
  end

  nodes.each_with_index do |(node_name, node_opts), i|
    config.vm.define node_name do |node|
      node_opts         = node_defaults.merge(node_opts)
      node.vm.hostname  = node_name
      node.vm.network   :private_network, ip: node_opts[:ip]
      node.vm.provision :hosts
      node.vm.provision :cucumber if node_name == 'jenkins'

      node.vm.provider :virtualbox do |vb|
        vb.memory = node_opts[:memory]
      end
    end
  end
end
