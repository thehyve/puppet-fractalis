# Class: fractalis
# ===========================
#
# Full description of class fractalis here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'fractalis':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Gijs Kant <gijs@thehyve.nl>
#
# Copyright
# ---------
#
# Copyright 2018 The Hyve B.V.
#
class fractalis inherits fractalis::params {

    include ::fractalis::dependencies

    $user = $::fractalis::params::user
    $home = $::fractalis::params::fractalis_user_home

    # Create fractalis user.
    user { $user:
        ensure     => present,
        home       => $home,
        managehome => true,
        shell      => '/bin/bash',
    }
    # Make home only accessible for the user
    -> file { $home:
        ensure => directory,
        mode   => '0711',
        owner  => $user,
    }

}
