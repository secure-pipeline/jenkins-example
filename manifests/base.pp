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

  jenkins::plugin {'cucumber-reports':}
  jenkins::plugin {'build-pipeline-plugin':}
  jenkins::plugin {'clamav':}
  jenkins::plugin {'git-client':}
  jenkins::plugin {'greenballs':}

  package { 'brakeman':
    ensure   => installed,
    provider => gem,
  }
}
