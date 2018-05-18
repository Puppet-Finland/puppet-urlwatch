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
#   A hash, where the attribute "url" defines the URL to monitor and the 
#   optional attribute "filter" defines a Python regular expression to be passed 
#   on to re.sub() in hooks.py. This allows removal of trivially changing parts 
#   of the web page before making comparisons. A typical example is a constantly 
#   timestamp or time entry such as "Modified by johndoe 2 weeks ago".
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
    String                   $system_user = $title,
    Enum['present','absent'] $ensure = 'present',
    Optional[Hash]           $urls = undef,
    Boolean                  $use_cron = true,
    Variant[Integer,String]  $hour = 9,
    Variant[Integer,String]  $minute = 15,
    Variant[Integer,String]  $weekday = '*'
)
{
    include ::urlwatch::params

    # Base directory for urlwatch configuration
    $basedir = "${::os::params::home}/${system_user}/.urlwatch"

    # This is where hooks.py is stored
    $libdir = "${basedir}/lib"

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

    file { "urlwatch-${libdir}":
        ensure  => directory,
        name    => $libdir,
        mode    => '0755',
        require => File["urlwatch-${basedir}"],
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
            content => template('urlwatch/urls.txt.erb'),
            mode    => '0644',
            require => File["urlwatch-${basedir}"],
        }

        file { "urlwatch-${libdir}/hooks.py":
            ensure  => $ensure,
            name    => "${libdir}/hooks.py",
            content => template('urlwatch/hooks.py.erb'),
            mode    => '0644',
            require => File["urlwatch-${libdir}"],
        }
    }
}
