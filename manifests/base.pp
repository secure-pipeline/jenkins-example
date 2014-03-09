Exec {
  path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

node 'base' {

  hiera_include('classes')

  ufw::allow { 'allow-ssh-from-all':
    port => 22,
  }

  sudo::conf { 'vagrant':
    priority => 30,
    content  => 'vagrant ALL=(ALL) NOPASSWD:ALL',
  }

  file { '/etc/update-motd.d':
    purge => true
  }

}

node 'jenkins' inherits 'base' {

  ufw::allow { 'allow-jenkins-from-all':
    port => 8080,
    ip   => $::ipaddress_eth1
  }

  package { 'brakeman':
    ensure   => installed,
    provider => gem,
  }

  # This should be removed soon, first install of brakeman triggered
  # a bug with the latest release of sass
  package { 'sass':
    ensure   => '3.2.15',
    provider => gem,
  }
}
