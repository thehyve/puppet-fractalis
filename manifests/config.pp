class fractalis::config inherits fractalis::params {

    $user = $::fractalis::params::user
    $home = $::fractalis::params::fractalis_user_home

    file { $::fractalis::params::log_config_location:
        ensure  => file,
        owner   => $user,
        mode    => '0640',
        content => template('fractalis/config/logging.yaml.erb'),
    }

    file { $::fractalis::params::config_location:
        ensure  => file,
        owner   => $user,
        mode    => '0640',
        content => template('fractalis/config/config.py.erb'),
    }

}
