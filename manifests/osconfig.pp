# == Class: pwk
#
# Perform various os configurations to secure/setup system
#
# Mike Kelly
#

class pwk::osconfig {

#===========================================
# Setup user account amd public key
#===========================================
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
  # Sudoers file change to nopasswd for wheel group
  augeas { 'sudo':
    context => '/files/etc/sudoers',
    changes => [
      'set spec[user = "%wheel"]/user %wheel',
      'set spec[user = "%wheel"]/host_group/host ALL',
      'set spec[user = "%wheel"]/host_group/command[1] ALL',
      'set spec[user = "%wheel"]/host_group/command[1]/tag NOPASSWD',
    ]
  }

#===========================================
# Disable password auth, ssh-key auth only
#===========================================
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
