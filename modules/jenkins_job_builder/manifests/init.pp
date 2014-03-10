# == Class: jenkins::job_builder
#
# Vendored from the OpenStack project
# https://git.openstack.org/cgit/openstack-infra/config/tree/modules/jenkins/manifests/job_builder.pp


class jenkins_job_builder (
  $url = '',
  $username = '',
  $password = '',
  $config_source = undef,
) {

  ensure_packages(['python-pip', 'python-yaml', 'python-jenkins'])

  vcsrepo { '/opt/jenkins_job_builder':
    ensure   => latest,
    provider => git,
    revision => 'master',
    source   => 'https://git.openstack.org/openstack-infra/jenkins-job-builder',
  }

  exec { 'install_jenkins_job_builder':
    command     => 'pip install /opt/jenkins_job_builder',
    path        => '/usr/local/bin:/usr/bin:/bin/',
    refreshonly => true,
    subscribe   => Vcsrepo['/opt/jenkins_job_builder'],
    require     => Package['python-pip'],
  }

  file { '/etc/jenkins_jobs':
    ensure => directory,
  }

  exec { 'jenkins_jobs_update':
    command     => 'jenkins-jobs update --delete-old /etc/jenkins_jobs/config',
    path        => '/bin:/usr/bin:/usr/local/bin',
    refreshonly => true,
    require     => [
      File['/etc/jenkins_jobs/jenkins_jobs.ini'],
      Package['python-jenkins'],
      Package['python-yaml'],
    ],
  }

  file { '/etc/jenkins_jobs/jenkins_jobs.ini':
    ensure  => present,
    mode    => '0400',
    content => template('jenkins_job_builder/jenkins_jobs.ini.erb'),
    require => File['/etc/jenkins_jobs'],
  }

  if $config_source {
    file { '/etc/jenkins_jobs/config':
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      recurse => true,
      purge   => true,
      force   => true,
      source  => $config_source,
      notify  => Exec['jenkins_jobs_update'],
    }
  }

}
