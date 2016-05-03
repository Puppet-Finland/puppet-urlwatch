# urlwatch

A Puppet module for managing urlwatch. This module also supports urlwatch's 
built-in filtering features (hooks.py).

# Module usage

Example: Monitor Trac WikiStart and RecentChanges pages for edits:

    classes:
        - urlwatch
    
    urlwatch::userconfigs:
        john:
            hour: '*'
            minute: '20'
            urls:
                trac_wikistart:
                    url: 'https://trac.domain.com/openvpn/wiki/WikiStart'
                    filter: '[0-9]* (year|month|week|day|hour|minute|second)s{0,1} ago'
                trac_recentchanges:
                    url: 'https://trac.domain.com/openvpn/wiki/RecentChanges'
                    filter: '[0-9]* (year|month|week|day|hour|minute|second)s{0,1} ago'

If you want the email to user 'john' to go to a public address, you can use the 
puppetfinland/postfix module:

    classes:
        - postfix
    
    postfix::mailaliases:
        john:
            recipient: 'john@domain.com'


For details please refer to the class documentation:

* [Class: urlwatch](manifests/init.pp)
* [Define: urlwatch::userconfig](manifests/userconfig.pp)

# Dependencies

For hard dependencies refer to [metadata.json](metadata.json). If you want to 
use the cron functionality in this module you probably want to set up some mail 
aliases. One way to do this is to use ::postfix::mailaliases hash parameter in 
the Puppet-Finland [postfix module](https://github.com/Puppet-Finland/postfix).

# Operating system support

This module has been tested on

* Debian 7

It should work out of the box or with small modifications on any *NIX-style 
operating system.

For details see [params.pp](manifests/params.pp).
