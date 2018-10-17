# @summary Manages PPA repositories using `add-apt-repository`. Not supported on Debian.
#
# @example Example declaration of an Apt PPA
#   apt::ppa{ 'ppa:openstack-ppa/bleeding-edge': }
#
# @param ensure
#   Specifies whether the PPA should exist. Valid options: 'present' and 'absent'.
#
# @param options
#   Supplies options to be passed to the `add-apt-repository` command. Default: '-y'.
#
# @param release
#   Optional if lsb-release is installed (unless you're using a different release than indicated by lsb-release, e.g., Linux Mint).
#   Specifies the operating system of your node. Valid options: a string containing a valid LSB distribution codename.
#
# @param package_name
#   Names the package that provides the `apt-add-repository` command. Default: 'software-properties-common'.
#
# @param package_manage
#   Specifies whether Puppet should manage the package that provides `apt-add-repository`.
#
define apt::ppa(
    String $ensure                 = 'present',
    Optional[String] $options      = $::apt::ppa_options,
    Optional[String] $release      = $facts['lsbdistcodename'],
    Optional[String] $package_name = $::apt::ppa_package,
    Boolean $package_manage        = false,
) {
    unless $release {
        fail(translate('lsbdistcodename fact not available: release parameter required'))
    }

    if $facts['lsbdistid'] == 'Debian' {
        fail(translate('apt::ppa is not currently supported on Debian.'))
    }

}
