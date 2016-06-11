# == Class: kokos
#
# Full description of class kokos here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'kokos':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Wojciech Krysmann
#
# === Copyright
#
# Copyright 2016 Wojciech Krysmann, unless otherwise noted.
#
class kokos-module {

include 'docker'
include 'docker_compose'

#prepare python env
class { 'python' :
  version    => 'system',
  pip        => 'present',
  dev        => 'absent',
  virtualenv => 'absent',
  gunicorn   => 'absent',
}

python::pip { 'elasticsearch' :
  pkgname       => 'elasticsearch',
  ensure        => 'latest',
  timeout       => 1800,
  require 	=> Class['python'],
 }

##clone ELK-stack docker repo
vcsrepo { '/opt/elk_repo':
  ensure   => present,
  provider => git,
  source   => 'https://github.com/deviantony/docker-elk',
}

##compose...
docker_compose { '/opt/elk_repo/docker-compose.yml':
  ensure  => present,
  require => Vcsrepo['/opt/elk_repo'],
}

}
