# == Class: pwk::packages
#
# Package installations
#
# Mike Kelly
#

class pwk::packages {

#===========================================
# Ensure repos
#===========================================
$passenger_repo = '[passenger]
name=passenger
baseurl=https://oss-binaries.phusionpassenger.com/yum/passenger/el/$releasever/$basearch
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt

[passenger-source]
name=passenger-source
baseurl=https://oss-binaries.phusionpassenger.com/yum/passenger/el/$releasever/SRPMS
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
'

  file { '/etc/yum.repos.d/passenger.repo':
    mode     => '0600',
    owner    => 'root',
    group    => 'root',
    before   => Package['mod_passenger'],
    content  => $passenger_repo

  }
  package { 'epel-release':
    ensure   => installed
  }
#===========================================
# Ensure packages we need
#===========================================
  package { 'rubygems':
    ensure   => present
  }
  package { 'mod_passenger':
    ensure   => installed,
  }
#===========================================
# Install packages i care about :)
#===========================================
  package { 'vim-enhanced':
    ensure   => installed
  }
  package { 'mlocate':
    ensure   => installed
  }
  package { 'tree':
    ensure   => installed
  }
  package { 'puppet-lint':
    ensure   => installed,
    provider => gem
  }
  package { 'git':
    ensure   => installed
  }
}
