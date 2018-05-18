#
# == Class: urlwatch
#
# This class sets up urlwatch
#
# == Parameters
#
# [*manage*]
#   Whether to manage urlwatch using Puppet. Valid values are true (default) 
#   and false.
# [*manage_config*]
#   Manage urlwatch configuration using Puppet. Valid values are true (default) 
#   and false.
# [*ensure*]
#   Status of urlwatch. Valid values are 'present' (default) and 'absent'.
# [*userconfigs*]
#   A hash of urlwatch::userconfig resources to realize.
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
    Boolean                  $manage = true,
    Boolean                  $manage_config = true,
    Enum['present','absent'] $ensure = 'present',
    Hash                     $userconfigs = {}

) inherits urlwatch::params
{

if $manage {

    class { '::urlwatch::install':
        ensure => $ensure,
    }

    if $manage_config {
        create_resources('urlwatch::userconfig', $userconfigs)
    }


}
}
