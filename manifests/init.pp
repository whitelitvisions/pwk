# == Class: pwk
#
# Puppet module to build pwk website for simple hosting
#
# Mike Kelly
#

class pwk {
  class { '::pwk::packages': }
	class { '::pwk::osconfig': }
}
