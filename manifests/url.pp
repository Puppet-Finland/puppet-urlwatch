#
# == Define: urlwatch::url
#
# Define an URL that urlwatch watches
#
# == Parameters
#
# [*ensure*]
#   Status of this watched URL. Valid values are 'present' and 'absent'.
# [*basedir*]
#   The urlwatch configuration directory. You will not need to define this 
#   unless you use this resource directly.
#
define urlwatch::url
(
    $ensure,
    $basedir
)
{
    include ::urlwatch::params

    file_line { $title:
        ensure  => $ensure,
        path    => "${basedir}/urls.txt",
        line    => $title,
        require => File["urlwatch-${basedir}/urls.txt"],
    }
}
