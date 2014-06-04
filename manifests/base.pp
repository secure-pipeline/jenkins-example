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
    port => 9090,
    ip   => $::ipaddress_eth1
  }

  # before -> after
  Class['jenkins'] -> Class['jenkins_job_builder']

  ensure_packages([
    'libxslt-dev',
    'libxml2-dev',
    'sqlite3',
    'libsqlite3-dev',
    'libmysqld-dev',
    'phantomjs',
  ])

  package { 'python-pip':
    ensure => installed,
  }

  package { [
    'brakeman',
    'bundler-audit',
    'ci_reporter',
    'zapr',
  ]:
    ensure   => installed,
    provider => gem,
  }

  package { [
    'jenkins-job-builder-brakeman',
    'jenkins-job-builder-clamav'
  ]:
    ensure   => installed,
    provider => pip,
    before   => Class['jenkins_job_builder'],
    require  => Package['python-pip'],
  }

  file_line { 'Enable ClamAV TCP':
    line    => 'TCPSocket 3310',
    path    => '/etc/clamav/clamd.conf',
    require => Class['clamav'],
  }

  file_line { 'Lockdown ClamAV TCP port':
    line    => 'TCPAddr 127.0.0.1',
    path    => '/etc/clamav/clamd.conf',
    require => Class['clamav'],
  }

  file { '/opt/src':
    ensure => directory,
  }

  wget::fetch { 'download owasp zap':
    source      => 'http://sourceforge.net/projects/zaproxy/files/2.3.1/ZAP_2.3.1_Linux.tar.gz/download',
    destination => '/opt/src/zap.tar.gz',
    require     => File['/opt/src'],
    before      => Exec['untar and move owasp zap'],
  }

  exec { 'untar and move owasp zap':
    command  => '/bin/tar -xvf zap.tar.gz; mv ZAP* /opt/zap',
    cwd      => '/opt/src',
    creates  => '/opt/zap',
  }

  # This should be removed soon, first install of brakeman triggered
  # a bug with the latest release of sass
  package { 'sass':
    ensure   => '3.2.15',
    provider => gem,
  }
}
