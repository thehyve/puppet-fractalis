# == Define: python::pip
#
# Installs and manages packages from pip.
#
# === Parameters
#
# [*name]
#  must be unique
#
# [*pkgname]
#  name of the package. If pkgname is not specified, use name (title) instead.
#
# [*ensure*]
#  present|absent. Default: present
#
# [*virtualenv*]
#  virtualenv to run pip in.
#
# [*pip_provider*]
#  version of pip you wish to use. Default: pip
#
# [*url*]
#  URL to install from. Default: none
#
# [*owner*]
#  The owner of the virtualenv being manipulated. Default: root
#
# [*group*]
#  The group of the virtualenv being manipulated. Default: root
#
# [*index*]
#  Base URL of Python package index. Default: none (http://pypi.python.org/simple/)
#
# [*proxy*]
#  Proxy server to use for outbound connections. Default: none
#
# [*editable*]
#  Boolean. If true the package is installed as an editable resource.
#
# [*environment*]
#  Additional environment variables required to install the packages. Default: none
#
# [*extras*]
#  Extra features provided by the package which should be installed. Default: none
#
# [*timeout*]
#  The maximum time in seconds the "pip install" command should take. Default: 1800
#
# [*install_args*]
#  String. Any additional installation arguments that will be supplied
#  when running pip install.
#
# [*uninstall_args*]
# String. Any additional arguments that will be supplied when running
# pip uninstall.
#
# [*log_dir*]
# String. Log directory.
#
# === Examples
#
# python::pip { 'flask':
#   virtualenv => '/var/www/project1',
#   proxy      => 'http://proxy.domain.com:3128',
#   index      => 'http://www.example.com/simple/',
# }
#
# === Authors
#
# Sergey Stankevich
# Fotis Gimian
# Daniel Quackenbush
#
define python::pip (
    $pkgname                             = $name,
    $ensure                              = present,
    $virtualenv                          = 'system',
    Enum['pip', 'pip3'] $pip_provider    = 'pip',
    $url                                 = false,
    $owner                               = 'root',
    $group                               = 'root',
    $umask                               = undef,
    $index                               = false,
    $proxy                               = false,
    $egg                                 = false,
    $editable                            = false,
    $environment                         = [],
    $extras                              = [],
    $install_args                        = '',
    $uninstall_args                      = '',
    $timeout                             = 1800,
    $log_dir                             = '/tmp',
    $path                                = ['/usr/local/bin','/usr/bin','/bin', '/usr/sbin'],
) {
}
