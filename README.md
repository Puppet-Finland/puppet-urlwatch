# urlwatch

A Puppet module for managing urlwatch

# Module usage

* [Class: urlwatch](manifests/init.pp)
* [Define: urlwatch::userconfig](manifests/userconfig.pp)
* [Define: urlwatch::url](manifests/url.pp)

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
