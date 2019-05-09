class fractalis::worker inherits fractalis::params {

    include ::fractalis::package
    include ::fractalis::config

    $user = $::fractalis::params::user
    $home = $::fractalis::params::fractalis_user_home
    $celery_command = "${::fractalis::params::python_environment}/bin/celery"
    $start_celery_script = "${home}/start_celery"
    $package_location = $::fractalis::params::package_location

    file { $start_celery_script:
        ensure  => file,
        owner   => $user,
        mode    => '0744',
        content => template('fractalis/service/start_celery.erb'),
        notify  => Service['fractalis-worker'],
    }
    -> file { '/etc/systemd/system/fractalis-worker.service':
        ensure  => file,
        mode    => '0644',
        content => template('fractalis/service/fractalis-worker.service.erb'),
        notify  => Service['fractalis-worker'],
    }
    # Start the application service
    -> service { 'fractalis-worker':
        ensure   => running,
        provider => 'systemd',
        enable   => true,
        require  => [
            Exec["Install fractalis ${::fractalis::package::version}"],
            Python::Pip['celery']
        ],
    }

}
