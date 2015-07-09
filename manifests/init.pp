#
# == Class: urlwatch
#
# This class sets up urlwatch
#
# == Parameters
#
# [*manage*]
#   Whether to manage urlwatch using Puppet. Valid values are 'yes' (default) 
#   and 'no'.
# [*manage_config*]
#   Manage urlwatch configuration using Puppet. Valid values 'yes' (default) and 
#   'no'.
# [*ensure*]
#   Status of urlwatch. Valid values are 'present' (default) and 'absent'.
# [*userconfigs*]
#   A hash of urlwatch::userconfig resources to realize.
#
# == Examples
#
# An example using Hiera:
#
#   classes:
#     - urlwatch
#   
#   urlwatch::userconfigs:
#     john:  
#       urls:
#         wiki:
#           url: 'wiki.domain.com':
#           # The wiki frontpage contains a timestamp which changes on every 
#           # fetch, so we need to filter it out.
#           filter: '[0-9]* (year|month|week|day|hour|minute)s{0,1} ago'
#         website:
#           url: 'www.domain.com'
#
# == Authors
#
# Samuli Seppänen <samuli@openvpn.net>
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class urlwatch
(
    $manage = 'yes',
    $manage_config = 'yes',
    $ensure = 'present',
    $userconfigs = {}

) inherits urlwatch::params
{

if $manage == 'yes' {

    class { '::urlwatch::install':
        ensure => $ensure,
    }

    if $manage_config == 'yes' {
        create_resources('urlwatch::userconfig', $userconfigs)
    }


}
}
