class fractalis::package inherits fractalis::params {

    include ::fractalis

    $user = $::fractalis::params::user
    $home = $::fractalis::params::fractalis_user_home
    $pip = "${::fractalis::params::python_environment}/bin/pip"
    $version = $::fractalis::package::version
    $archive_location = "${home}/Fractalis-${::fractalis::params::source_tag}.zip"

    archive { $archive_location:
        ensure       => present,
        extract      => true,
        extract_path => $home,
        source       => $::fractalis::params::source,
        creates      => $::fractalis::params::package_location,
        cleanup      => true,
        user         => $user,
    }

    exec { "Install fractalis ${version}":
        command => "${pip} install .",
        path    => ['/bin', '/usr/bin', '/usr/local/bin', "${::fractalis::params::python_environment}/bin"],
        unless  => "[ \"$(${pip} show fractalis | grep \"Version: \")\" = \"Version: ${version}\" ]",
        require => [
            Archive[$archive_location],
            Python::Pip['setuptools'],
            Package['r-base'],
        ],
        cwd     => $::fractalis::params::package_location,
        user    => $user,
    }

}
