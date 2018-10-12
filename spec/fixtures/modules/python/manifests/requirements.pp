# == Define: python::requirements
#
# Installs and manages Python packages from requirements file.
#
# === Parameters
#
# [*requirements*]
#  Path to the requirements file. Defaults to the resource name
#
# [*virtualenv*]
#  virtualenv to run pip in. Default: system-wide
#
# [*pip_provider*]
#  version of pip you wish to use. Default: pip
#
# [*owner*]
#  The owner of the virtualenv being manipulated. Default: root
#
# [*group*]
#  The group relating to the virtualenv being manipulated. Default: root
#
# [*proxy*]
#  Proxy server to use for outbound connections. Default: none
#
# [*src*]
# Pip --src parameter; if the requirements file contains --editable resources,
# this parameter specifies where they will be installed. See the pip
# documentation for more. Default: none (i.e. use the pip default).
#
# [*environment*]
#  Additional environment variables required to install the packages. Default: none
#
# [*forceupdate*]
#  Run a pip install requirements even if we don't receive an event from the
# requirements file - Useful for when the requirements file is written as part of a
# resource other than file (E.g vcsrepo)
#
# [*cwd*]
#  The directory from which to run the "pip install" command. Default: undef
#
# [*extra_pip_args*]
# Extra arguments to pass to pip after the requirements file
#
# [*manage_requirements*]
# Create the requirements file if it doesn't exist. Default: true
#
# [*fix_requirements_owner*]
# Change owner and group of requirements file. Default: true
#
# [*log_dir*]
# String. Log directory.
#
# [*timeout*]
#  The maximum time in seconds the "pip install" command should take. Default: 1800
#
# === Examples
#
# python::requirements { '/var/www/project1/requirements.txt':
#   virtualenv => '/var/www/project1',
#   proxy      => 'http://proxy.domain.com:3128',
# }
#
# === Authors
#
# Sergey Stankevich
# Ashley Penney
# Fotis Gimian
# Daniel Quackenbush
#
define python::requirements (
    $requirements                       = $name,
    $virtualenv                         = 'system',
    Enum['pip', 'pip3'] $pip_provider   = 'pip',
    $owner                              = 'root',
    $group                              = 'root',
    $proxy                              = false,
    $src                                = false,
    $environment                        = [],
    $forceupdate                        = false,
    $cwd                                = undef,
    $extra_pip_args                     = '',
    $manage_requirements                = true,
    $fix_requirements_owner             = true,
    $log_dir                            = '/tmp',
    $timeout                            = 1800,
) {

    include ::python

    if $virtualenv == 'system' and ($owner != 'root' or $group != 'root') {
        fail('python::pip: root user must be used when virtualenv is system')
    }

}
