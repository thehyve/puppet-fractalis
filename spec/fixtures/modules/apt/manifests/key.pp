# @summary Manages the GPG keys that Apt uses to authenticate packages.
#
# @note
#   The apt::key defined type makes use of the apt_key type, but includes extra functionality to help prevent duplicate keys.
#
# @example Declare Apt key for apt.puppetlabs.com source
#   apt::key { 'puppetlabs':
#     id      => '6F6B15509CF8E59E6E469F327F438280EF8D349F',
#     server  => 'hkps.pool.sks-keyservers.net',
#     options => 'http-proxy="http://proxyuser:proxypass@example.org:3128"',
#   }
#
# @param id
#   Specifies a GPG key to authenticate Apt package signatures. Valid options: a string containing a key ID (8 or 16 hexadecimal
#   characters, optionally prefixed with "0x") or a full key fingerprint (40 hexadecimal characters).
#
# @param ensure
#   Specifies whether the key should exist. Valid options: 'present', 'absent' or 'refreshed'. Using 'refreshed' will make keys auto
#   update when they have expired (assuming a new key exists on the key server).
#
# @param content
#   Supplies the entire GPG key. Useful in case the key can't be fetched from a remote location and using a file resource is inconvenient.
#
# @param source
#   Specifies the location of an existing GPG key file to copy. Valid options: a string containing a URL (ftp://, http://, or https://) or
#   an absolute path.
#
# @param server
#   Specifies a keyserver to provide the GPG key. Valid options: a string containing a domain name or a full URL (http://, https://, or
#   hkp://).
#
# @param options
#   Passes additional options to `apt-key adv --keyserver-options`.
#
define apt::key (
    Pattern[/\A(0x)?[0-9a-fA-F]{8}\Z/, /\A(0x)?[0-9a-fA-F]{16}\Z/, /\A(0x)?[0-9a-fA-F]{40}\Z/] $id = $title,
    Enum['present', 'absent', 'refreshed'] $ensure                                                 = present,
    Optional[String] $content                                                                      = undef,
    Optional[Pattern[/\Ahttps?:\/\//, /\Aftp:\/\//, /\A\/\w+/]] $source                            = undef,
    Pattern[/\A((hkp|http|https):\/\/)?([a-z\d])([a-z\d-]{0,61}\.)+[a-z\d]+(:\d{2,5})?$/] $server  = $::apt::keyserver,
    Optional[String] $options                                                                      = undef,
) {

}
