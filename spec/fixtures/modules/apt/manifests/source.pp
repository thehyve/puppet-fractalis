# @summary Manages the Apt sources in /etc/apt/sources.list.d/.
#
# @example Install the puppetlabs apt source
#   apt::source { 'puppetlabs':
#     location => 'http://apt.puppetlabs.com',
#     repos    => 'main',
#     key      => {
#       id     => '6F6B15509CF8E59E6E469F327F438280EF8D349F',
#       server => 'hkps.pool.sks-keyservers.net',
#     },
#   }
#
# @param location
#   Required, unless ensure is set to 'absent'. Specifies an Apt repository. Valid options: a string containing a repository URL.
#
# @param comment
#   Supplies a comment for adding to the Apt source file.
#
# @param ensure
#   Specifies whether the Apt source file should exist. Valid options: 'present' and 'absent'.
#
# @param release
#   Specifies a distribution of the Apt repository.
#
# @param repos
#   Specifies a component of the Apt repository.
#
# @param include
#   Configures include options. Valid options: a hash of available keys.
#
# @option include [Boolean] :deb
#   Specifies whether to request the distribution's compiled binaries. Default true.
#
# @option include [Boolean] :src
#   Specifies whether to request the distribution's uncompiled source code. Default false.
#
# @param key
#   Creates a declaration of the apt::key defined type. Valid options: a string to be passed to the `id` parameter of the `apt::key`
#   defined type, or a hash of `parameter => value` pairs to be passed to `apt::key`'s `id`, `server`, `content`, `source`, and/or
#   `options` parameters.
#
# @param pin
#   Creates a declaration of the apt::pin defined type. Valid options: a number or string to be passed to the `id` parameter of the
#   `apt::pin` defined type, or a hash of `parameter => value` pairs to be passed to `apt::pin`'s corresponding parameters.
#
# @param architecture
#   Tells Apt to only download information for specified architectures. Valid options: a string containing one or more architecture names,
#   separated by commas (e.g., 'i386' or 'i386,alpha,powerpc'). Default: undef (if unspecified, Apt downloads information for all architectures
#   defined in the Apt::Architectures option).
#
# @param allow_unsigned
#   Specifies whether to authenticate packages from this release, even if the Release file is not signed or the signature can't be checked.
#
# @param notify_update
#   Specifies whether to trigger an `apt-get update` run.
#
define apt::source(
    Optional[String] $location                    = undef,
    String $comment                               = $name,
    String $ensure                                = present,
    Optional[String] $release                     = undef,
    String $repos                                 = 'main',
    Optional[Variant[Hash]] $include              = {},
    Optional[Variant[String, Hash]] $key          = undef,
    Optional[Variant[Hash, Numeric, String]] $pin = undef,
    Optional[String] $architecture                = undef,
    Boolean $allow_unsigned                       = false,
    Boolean $notify_update                        = true,
) {

    include ::apt

    if !$release {
        if $facts['lsbdistcodename'] {
            $_release = $facts['lsbdistcodename']
        } else {
            fail(translate('lsbdistcodename fact not available: release parameter required'))
        }
    } else {
        $_release = $release
    }

}