# == Class: pwk
#
# Full description of class pwk here.
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
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { pwk:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2011 Your name here, unless otherwise noted.
#
class pwk {

##########################################
#Ensure rubygems so we can use gem provider
##########################################
package { 'rubygems':
  ensure => present,
}
##########################################
#Install packages i care about :)
##########################################
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
##########################################
#Setup user account amd public key
##########################################
user { 'pwkbrewing':
  ensure => present,
  comment => 'People We Know Brewing',
  home => '/home/pwkbrewing',
  groups => 'wheel',
  managehome => true,
}
ssh_authorized_key { 'pwkbrewing_ssh':
  user => 'pwkbrewing',
  type => 'rsa',
  key =>  'AAAAB3NzaC1yc2EAAAADAQABAAABAQCvazcy/ZyZCfsHljtK76VZXplMylQweipO4tHs9bUdQM7Jnl5//6akwB2lj1bQbC4n3gs3evI6ZOWPL8tnfLdtR0zQAWuGIfpEX9bbbzUWsm5bKoaglrhTWKToDC1qQcMEe7nLtqpAmPw95lwJWyZZv1MQKAzDuXkTwJUebytLn3Rji1uRSNpV8W7RTOvbu5PFFDNAJYekNKRnvuCqZeU8e8WoyTXkswN0OLblXp06x94zsyBUN9ETqmz5rck65QcGYtaGBDF+/ghk5iUwt5MKZzLYlC8zWgp4fB/aq7yiZxFFGigM5NvZlOk6hpnfw2NILPWJ5bzQJygtdDlatVWz',
}

##########################################
#Security is nice
#Disable password auth, key only
##########################################

package { "openssh-server":
  ensure => "installed",
}

service { "sshd":
  ensure    => running,
  hasstatus => true,
  require   => Package["openssh-server"],
}

augeas { "sshd_config":
  context => "/files/etc/ssh/sshd_config",
  changes => [
    "set PermitRootLogin no",
    "set PubkeyAuthentication yes",
    "set PasswordAuthentication no",
    "set Port 22",
    "set PermitRootLogin no"
    ],
  notify => Service["sshd"],
}

}
