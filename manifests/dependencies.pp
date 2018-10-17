class fractalis::dependencies inherits fractalis::params {

    $user = $::fractalis::params::user
    $python_environment = $::fractalis::params::python_environment

    package { 'redis-server': }

    if !defined('::rabbitmq') {
        class { '::rabbitmq':
            node_ip_address => '127.0.0.1',
        }
    }

    if ($facts['os']['family'] == 'Debian' and $facts['lsbdistid'] == 'Ubuntu') {
        include apt
        apt::ppa { 'ppa:jonathonf/python-3.6': }
    }

    package { 'r-base': }

    ::fractalis::bioconductor_package { 'limma': }
    ::fractalis::bioconductor_package { 'DESeq2': }

    class { '::python':
        version    => 'python3.6',
        pip        => 'present',
        dev        => 'present',
        virtualenv => 'present',
    }
    -> ::python::virtualenv { $python_environment:
        ensure     => present,
        version    => '3.6',
        owner      => $user,
        distribute => false,
    }
    -> ::python::pip { 'setuptools':
        ensure     => latest,
        virtualenv => $python_environment,
    }

    ::python::pip { 'celery':
        ensure     => latest,
        virtualenv => $python_environment,
        require    => Python::Virtualenv[$python_environment],
    }

    ::python::pip { 'gunicorn':
        ensure     => latest,
        virtualenv => $python_environment,
        require    => Python::Virtualenv[$python_environment],
    }

}
