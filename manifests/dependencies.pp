class fractalis::dependencies inherits fractalis::params {

    $user = $::fractalis::params::user
    $python_environment = $::fractalis::params::python_environment

    package { 'redis-server': }

    class { '::rabbitmq':
        node_ip_address => '127.0.0.1',
        manage_python   => false,
    }

    case $facts['os']['family'] {
        'Debian': {
            $libxml_package = 'libxml2-dev'
        }
        'Redhat': {
            $libxml_package = 'libxml2-devel'
        }
        default: {
            fail("The fractalis module is not supported on an ${facts['os']['family']} based system.")
        }
    }
    package { $libxml_package: }

    ::fractalis::bioconductor_package { 'limma': }
    ::fractalis::bioconductor_package { 'DESeq2': }

    if ($facts['os']['family'] == 'Debian' and $facts['lsbdistid'] == 'Ubuntu') {
        include apt
        apt::ppa { 'ppa:jonathonf/python-3.6': }
        -> class { '::python':
            version    => 'python3.6',
            pip        => 'present',
            dev        => 'present',
            virtualenv => 'present',
        }

        $release = $facts['lsbdistcodename']
        apt::key { 'r-project':
            id     => 'E298A3A825C0D65DFD57CBB651716619E084DAB9',
            server => 'keyserver.ubuntu.com',
        }
        -> file { '/etc/apt/sources.list.d/r-project.list':
            ensure  => file,
            mode    => '0644',
            content => template('fractalis/sources/r-project.list.erb'),
        }
        -> package { 'r-base':
            ensure  => latest,
            require => Package[$libxml_package],
        }
    } else {
        class { '::python':
            version    => 'python3.6',
            pip        => 'present',
            dev        => 'present',
            virtualenv => 'present',
        }

        package { 'r-base':
            require => Package[$libxml_package],
        }
    }

    ::python::virtualenv { $python_environment:
        ensure     => present,
        version    => '3.6',
        owner      => $user,
        distribute => false,
        require    => Class['::python'],
    }
    -> ::python::pip { 'setuptools':
        ensure     => latest,
        virtualenv => $python_environment,
    }

    ::python::pip { 'celery':
        ensure     => latest,
        virtualenv => $python_environment,
        owner      => $user,
        require    => Python::Virtualenv[$python_environment],
    }

    ::python::pip { 'gunicorn':
        ensure     => latest,
        virtualenv => $python_environment,
        owner      => $user,
        require    => Python::Virtualenv[$python_environment],
    }

}
