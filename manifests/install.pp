#
# == Class: urlwatch::install
#
# This class installs urlwatch
#
class urlwatch::install
(
    Enum['present','absent'] $ensure

) inherits urlwatch::params
{
    package { $::urlwatch::params::package_name:
        ensure => $ensure,
    }
}
