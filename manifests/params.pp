#
# == Class: urlwatch::params
#
# Defines some variables based on the operating system
#
class urlwatch::params {

    include ::os::params

    case $::osfamily {
        'Debian': {
            $package_name = 'urlwatch'
        }
        default: {
            fail("Unsupported OS: ${::osfamily}")
        }
    }
}
