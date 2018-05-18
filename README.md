# urlwatch

A Puppet module for managing urlwatch and urlwatch cronjobs. This module also supports urlwatch's 
built-in filtering features (hooks.py).

# Module usage

Example using Hiera: monitor Trac WikiStart and RecentChanges pages for edits:

    classes:
        - urlwatch
    
    urlwatch::userconfigs:
        john:
            hour: '*'
            minute: '20'
            urls:
                trac_wikistart:
                    url: 'https://trac.example.org/openvpn/wiki/WikiStart'
                    filter: '[0-9]* (year|month|week|day|hour|minute|second)s{0,1} ago'
                trac_recentchanges:
                    url: 'https://trac.example.org/openvpn/wiki/RecentChanges'
                    filter: '[0-9]* (year|month|week|day|hour|minute|second)s{0,1} ago'

If you want the email to user 'john' to go to a public address, you can use the 
puppetfinland/postfix module:

    classes:
        - postfix
    
    postfix::mailaliases:
        john:
            recipient: 'john@example.org'

For details please refer to [init.pp](manifests/init.pp) and [userconfig.pp](manifests/userconfig.pp).

If you want to use the cron functionality in this module you probably want to
set up some mail aliases. One way to do this is to use ::postfix::mailaliases
hash parameter in the Puppet-Finland [postfix module](https://github.com/Puppet-Finland/postfix).
