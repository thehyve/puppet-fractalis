# == Define: python::virtualenv
#
# Creates Python virtualenv.
#
# === Parameters
#
# [*ensure*]
#  present|absent. Default: present
#
# [*version*]
#  Python version to use. Default: system default
#
# [*requirements*]
#  Path to pip requirements.txt file. Default: none
#
# [*systempkgs*]
#  Copy system site-packages into virtualenv. Default: don't
#  If virtualenv version < 1.7 this flag has no effect since
#
# [*venv_dir*]
#  Directory to install virtualenv to. Default: $name
#
# [*ensure_venv_dir*]
# Create $venv_dir. Default: true
#
# [*distribute*]
#  Include distribute in the virtualenv. Default: true
#
# [*index*]
#  Base URL of Python package index. Default: none (http://pypi.python.org/simple/)
#
# [*owner*]
#  The owner of the virtualenv being manipulated. Default: root
#
# [*group*]
#  The group relating to the virtualenv being manipulated. Default: root
#
# [*mode*]
# Optionally specify directory mode. Default: 0755
#
# [*proxy*]
#  Proxy server to use for outbound connections. Default: none
#
# [*environment*]
#  Additional environment variables required to install the packages. Default: none
#
# [*path*]
#  Specifies the PATH variable. Default: [ '/bin', '/usr/bin', '/usr/sbin' ]
#
# [*cwd*]
#  The directory from which to run the "pip install" command. Default: undef
#
# [*timeout*]
#  The maximum time in seconds the "pip install" command should take. Default: 1800
#
# [*pip_args*]
#  Arguments to pass to pip during initialization.  Default: blank
#
# [*extra_pip_args*]
#  Extra arguments to pass to pip after requirements file.  Default: blank
#
# === Examples
#
# python::virtualenv { '/var/www/project1':
#   ensure       => present,
#   version      => 'system',
#   requirements => '/var/www/project1/requirements.txt',
#   proxy        => 'http://proxy.domain.com:3128',
#   systempkgs   => true,
#   index        => 'http://www.example.com/simple/',
# }
#
# === Authors
#
# Sergey Stankevich
# Shiva Poudel
#
define python::virtualenv (
    $ensure           = present,
    $version          = 'system',
    $requirements     = false,
    $systempkgs       = false,
    $venv_dir         = $name,
    $ensure_venv_dir  = true,
    $distribute       = true,
    $index            = false,
    $owner            = 'root',
    $group            = 'root',
    $mode             = '0755',
    $proxy            = false,
    $environment      = [],
    $path             = [ '/bin', '/usr/bin', '/usr/sbin', '/usr/local/bin' ],
    $cwd              = undef,
    $timeout          = 1800,
    $pip_args         = '',
    $extra_pip_args   = '',
    $virtualenv       = undef
) {
    include ::python
}
