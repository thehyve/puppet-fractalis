class fractalis::app inherits fractalis::params {

    include ::fractalis::package
    include ::fractalis::config

    $user = $::fractalis::params::user
    $home = $::fractalis::params::fractalis_user_home
    $gunicorn_command = "${::fractalis::params::python_environment}/bin/gunicorn"
    $start_gunicorn_script = "${home}/start_gunicorn"
    $package_location = $::fractalis::params::package_location

    file { $start_gunicorn_script:
        ensure  => file,
        owner   => $user,
        mode    => '0744',
        content => template('fractalis/service/start_gunicorn.erb'),
        notify  => Service['fractalis-app'],
    }
    -> file { '/etc/systemd/system/fractalis-app.service':
        ensure  => file,
        mode    => '0644',
        content => template('fractalis/service/fractalis-app.service.erb'),
        notify  => Service['fractalis-app'],
    }
    # Start the application service
    -> service { 'fractalis-app':
        ensure   => running,
        provider => 'systemd',
        enable   => true,
        require  => [
            Exec["Install fractalis ${::fractalis::package::version}"],
            Python::Pip['gunicorn']
        ],
    }

}
