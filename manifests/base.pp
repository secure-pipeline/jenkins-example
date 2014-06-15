Exec {
  path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

node 'base' {

  hiera_include('classes')

  users { 'base': }

  ufw::allow { 'allow-ssh-from-all':
    port => 22,
    ip   => 'any',
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

  ufw::allow { 'allow-jenkins-proxy-from-all':
    port => 80,
    ip   => 'any',
  }

  ufw::allow { 'allow-jenkins-from-all':
    port => 9090,
    ip   => 'any',
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
    'sloccount',
  ])

  package { 'python-pip':
    ensure => installed,
  }

  package { [
    'brakeman',
    'bundler-audit',
    'gemrat',
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

  $clamav_config = "<?xml version='1.0' encoding='UTF-8'?>
<org.jenkinsci.plugins.clamav.ClamAvRecorder_-DescriptorImpl plugin=\"clamav@0.2.1\">
  <host>localhost</host>
  <port>3310</port>
  <timeout>10000</timeout>
  <scanArchivedArtifacts>false</scanArchivedArtifacts>
</org.jenkinsci.plugins.clamav.ClamAvRecorder_-DescriptorImpl>"

  file { '/var/lib/jenkins/org.jenkinsci.plugins.clamav.ClamAvRecorder.xml':
    ensure  => present,
    owner   => 'jenkins',
    group   => 'jenkins',
    content => $clamav_config,
  }

  file_line { 'Enable ClamAV TCP':
    line    => 'TCPSocket 3310',
    path    => '/etc/clamav/clamd.conf',
    require => Class['clamav'],
    notify  => Exec['refresh-clamav'],
  }

  file_line { 'Lockdown ClamAV TCP port':
    line    => 'TCPAddr 127.0.0.1',
    path    => '/etc/clamav/clamd.conf',
    require => Class['clamav'],
    notify  => Exec['refresh-clamav'],
  }

  exec { 'refresh-clamav':
    command     => 'freshclam',
    timeout     => 0,
    refreshonly => true,
    notify      => Exec['restart-clamav'],
  }

  exec { 'restart-clamav':
    command     => 'service clamav-daemon restart',
    refreshonly => true,
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
