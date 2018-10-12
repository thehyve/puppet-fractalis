define fractalis::bioconductor_package {

    include ::r

    case $::osfamily {
        'Debian', 'RedHat': {
            $binary = '/usr/bin/R'
        }
        default: { fail("Not supported on osfamily ${::osfamily}") }
    }
    $command = "${binary} -e 'source(\"https://bioconductor.org/biocLite.R\"); biocLite(); biocLite(c(\"${name}\"))'"

    exec { "install_bioconductor_package_${name}":
        command => $command,
        unless  => "${binary} -q -e \"'${name}' %in% installed.packages()\" | grep 'TRUE'",
        require => Class['r'],
    }

}
