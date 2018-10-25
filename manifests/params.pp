# Copyright 2018 The Hyve.
class fractalis::params(
    String[1] $hostname                         = lookup('fractalis::hostname', String),

    String[1] $user                             = lookup('fractalis::user', String, first, 'fractalis'),
    Optional[String[2]] $user_home              = lookup('fractalis::user_home', Optional[String[2]], first, undef),
    String[1] $version                          = lookup('fractalis::version', String, first, 'v1.3.1'),
    String[1] $source_version                   = lookup('fractalis::source_version', String, first, 'v1.3.1'),
    Optional[String[1]] $source_url             = lookup('fractalis::source_url', Optional[String[1]], first, undef),
) {
    # Set fractalis user home directory
    if $user_home == undef {
        $fractalis_user_home = "/home/${user}"
    } else {
        $fractalis_user_home = $user_home
    }

    if $source_url == undef {
        $source_tag = $source_version
        $source = "https://git-r3lab.uni.lu/Fractalis/fractalis/-/archive/${source_version}/fractalis-${source_version}.zip"
    } else {
        $source_tag = $version
        $source = $::fractalis::params::source_url
    }
    $package_location = "${fractalis_user_home}/fractalis-${source_tag}"

    $python_environment = "${fractalis_user_home}/environment"
    $config_location = "${fractalis_user_home}/config.py"
    $log_config_location = "${fractalis_user_home}/logging.yaml"

}
