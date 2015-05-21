#
# == Define: urlwatch::userconfig
#
# Configure urlwatch for a system user
#
# == Parameters
#
# [*system_user*]
#   The system user to configure urlwatch for. Defaults to resource $title.
# [*ensure*]
#   Whether this user's configurations should be 'present' (default) or 'absent'
# [*urls*]
#   An array of URLs to monitor.
# [*use_cron*]
#   Add a crontab entry for urlwatch. Valid values are true (default) and false. 
#   Use ::postfix::mailaliases to ensure that this system user's email is 
#   forwarded to the correct email address.
# [*hour*]
#   Hour(s) when urlwatch gets run from cron. Defaults to 9.
# [*minute*]
#   Minute(s) when urlwatch gets run from cron. Defaults to 15.
# [*weekday*]
#   Weekday(s) when urlwatch gets run from cron. Defaults to '*' (all weekdays).
#
define urlwatch::userconfig
(
    $system_user = $title,
    $ensure = 'present',
    $urls = undef,
    $use_cron = true,
    $hour = 9,
    $minute = 15,
    $weekday = '*'
)
{
    include ::urlwatch::params

    $basedir = "${::os::params::home}/${system_user}/.urlwatch"

    File {
        owner  => $system_user,
        group  => $system_user,
    }

    # If we tried to ensure that this is 'absent', Puppet would complain on 
    # every run. We don't want to force deletion, either, as urlwatch stores 
    # various other files in this directory.
    file { "urlwatch-${basedir}":
        ensure => directory,
        name   => $basedir,
        mode   => '0755',
    }

    if $use_cron {
        cron { "urlwatch-${system_user}":
            ensure      => $ensure,
            command     => 'urlwatch',
            user        => $system_user,
            hour        => $hour,
            minute      => $minute,
            weekday     => $weekday,
            environment => ['PATH=/bin:/usr/bin:/usr/local/bin'],
            require     => Class['urlwatch::install'],
        }
    }

    if $urls {

        # This file can't be deleted or the file_line entries in ::urlwatch::url 
        # will fail. Hence it's always 'present'.
        file { "urlwatch-${basedir}/urls.txt":
            ensure  => present,
            name    => "${basedir}/urls.txt",
            mode    => '0644',
            require => File["urlwatch-${basedir}"],
        }

        urlwatch::url { $urls:
            ensure  => $ensure,
            basedir => $basedir,
        }
    }
}
