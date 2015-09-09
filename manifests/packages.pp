# == Class: pwk::packages
#
# Package installations
#
# Mike Kelly
#

class pwk::packages {

#===========================================
# Ensure rubygems so we can use gem provider
#===========================================
  package { 'rubygems':
    ensure => present,
  }
#===========================================
# Install packages i care about :)
#===========================================
  package { 'vim-enhanced':
    ensure  => 'installed',
  }
  package { 'mlocate':
    ensure  => 'installed',
  }
  package { 'tree':
    ensure  => 'installed',
  }
  package { 'puppet-lint':
    ensure  => 'installed',
    provider => 'gem',
  }
  package { 'git':
    ensure  => 'installed',
  }
}
