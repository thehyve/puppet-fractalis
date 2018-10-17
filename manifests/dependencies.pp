class fractalis::dependencies inherits fractalis::params {

    $user = $::fractalis::params::user
    $python_environment = $::fractalis::params::python_environment

    package { 'redis-server': }

    if !defined('::rabbitmq') {
        class { '::rabbitmq':
            node_ip_address => '127.0.0.1',
        }
    }

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

        apt::source { 'r-project':
            location => 'https://cloud.r-project.org/bin/linux/ubuntu',
            repos    => '',
            key      => {
                'id'     => 'E298A3A825C0D65DFD57CBB651716619E084DAB9',
                'server' => 'keyserver.ubuntu.com',
            },
        }
        -> package { 'r-base': }
    } else {
        class { '::python':
            version    => 'python3.6',
            pip        => 'present',
            dev        => 'present',
            virtualenv => 'present',
        }

        package { 'r-base': }
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
        require    => Python::Virtualenv[$python_environment],
    }

    ::python::pip { 'gunicorn':
        ensure     => latest,
        virtualenv => $python_environment,
        require    => Python::Virtualenv[$python_environment],
    }

}
