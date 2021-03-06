<!--
This file is part of the doubledog-openssh Puppet module.
Copyright 2017-2020 John Florian <jflorian@doubledog.org>
SPDX-License-Identifier: GPL-3.0-or-later
-->

# openssh

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with openssh](#setup)
    * [What openssh affects](#what-openssh-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with openssh](#beginning-with-openssh)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
    * [Defined types](#defined-types)
    * [Data types](#data-types)
    * [Facts](#facts)
    * [Functions](#functions)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

OpenSSH managed by Puppet, my way, the paranoid way.

## Setup

### What openssh Affects

### Setup Requirements

### Beginning with openssh

## Usage

## Reference

**Classes:**

* [openssh::hostkeys](#opensshhostkeys-class)
* [openssh::server](#opensshserver-class)

**Defined types:**

* [openssh::known\_host](#opensshknown\_host-defined-type)
* [openssh::server::config](#opensshserverconfig-defined-type)

**Data types:**

**Facts:**

**Functions:**

* [openssh::ipaddresses](#opensshipaddresses-function)


### Classes

#### openssh::hostkeys class

This class manages the public host keys for the OpenSSH server.  It will export all common keys discovered and simultaneously import all previously exported keys so that each is known to the OpenSSH server as a trusted "known host".

Any "known host" keys that are configured for the server, but which are not found as exports, can be automatically deleted.  This behavior eliminates any false or obsolete trust and works best when exported resources are set to auto-expire if not regularly refreshed via constant export.

##### `aliases`
An array of other valid identities for this host.  By default, the host key of each type will be associated with the short hostname (e.g., `burmese`), the fully-qualified hostname (e.g., `burmese.python.org`) and its primary (as determined by facter) IP address.  If this parameter is set, it's only necessary to specify any other identities as the default identities will be applied regardless.

##### `exclude_interfaces`
An array interface name prefixes to be excluded when searching for IP addresses to be used as additional aliases for the host keys.  The default is `['lo']` but you might wish to also exclude temporary interfaces, such as those for VPN tunnels, e.g., `['lo', 'tun']`.

##### `purge_keys`
If `true` (the default), then purge any and all host keys existing in the system-wide "known hosts" file that are not managed by Puppet.  This has no effect on any other "known hosts" files such as those per user.


#### openssh::server class

This class manages the OpenSSH server package installation, configuration and service.

##### `configs`
A hash whose keys are drop-in configuration filenames and whose values are hashes comprising the same parameters you would otherwise pass to the [openssh::server::config](#opensshserverconfig-defined-type) defined type.  The default is none.

##### `content`
Literal content for the server's configuration file.  If neither `content` nor `source` is given, the content of the file will be left unmanaged, though file ownership, mode, SELinux context, etc. will continue to be managed.

##### `enable`
Instance is to be started at boot.  Either `true` (default) or `false`.

##### `ensure`
Instance is to be `running` (default) or `stopped`.  Alternatively, a Boolean value may also be used with `true` equivalent to `running` and `false` equivalent to `stopped`.

##### `include_dir`
Name of the directory where the server expects drop-in configuration files.  The default is `'/etc/ssh/ssh_config.d'`.

##### `known_hosts`
A hash whose keys are known host resource names and whose values are hashes comprising the same parameters you would otherwise pass to the [openssh::known\_host](#opensshknown\_host-defined-type) defined type.  The default is none.

This is primarily intended for additional public keys of those hosts not managed by Puppet.  For those managed by Puppet, see the [openssh::hostkeys](#opensshhostkeys-class) class instead.

##### `manage_firewall`
A Boolean value indicating whether to manage the firewall or not.  Defaults to `true`.

##### `packages`
An array of package names needed for the OpenSSH server installation.  The default should be correct for supported platforms.

##### `service`
The service names needed for the OpenSSH server.  The default should be correct for supported platforms.

##### `source`
URI of the server's configuration file content.  If neither `content` nor `source` is given, the content of the file will be left unmanaged, though file ownership, mode, SELinux context, etc. will continue to be managed.


### Defined types

#### openssh::known\_host defined type

This defined type manages a OpenSSH known host's public key.  While the [openssh::hostkeys](#opensshhostkeys-class) class is the ideal way to manage the public host keys for the OpenSSH server where the Puppet catalog is being applied, this defined type proves useful for making other public host keys known that would not otherwise be collected by Puppet.  Some common examples are:

* servers you access, but do not manage (e.g., GitHub)
* hardware management (e.g., a managed network switch)

If you have many, you may wish to define them via Hiera and the *known_hosts* parameter on the [openssh::server](#opensshserver-class) class.

##### `namevar` (required)
An arbitrary identifier for the instance unless the *key_name* parameter is not set in which case this must provide the value normally set with the *key_name* parameter.

##### `aliases` (required)
An array of identities for this host.  These can be short hostnames, fully-qualified domain names, or IP addresses.  This array will be flattened (in case there are nested arrays), de-duplicated and sorted.

##### `type` (required)
The SSH host key type.  Must be one of Puppet's own [sshkey](https://puppet.com/docs/puppet/5.5/types/sshkey.html#sshkey-attribute-type) resource type.  (Those without the `'ssh-'` prefix are preferred.)

##### `ensure`
Instance is to be `present` (default) or `absent`.

##### `key`
The public key itself.


#### openssh::server::config defined type

This defined type manages a drop-in configuration file for the OpenSSH server.  This is the preferred means for custom configurations as it minimizes disruptions to distribution configurations, but many of those have only recently adopted this practice so the main configuration must still be managed.  To use these, your main configuration (via *openssh::server::content* or *openssh::server::source*) must have an `Include` directive targeting *openssh::server::include_dir*.

These are typically instantiated via Hiera and the *configs* parameter on the [openssh::server](#opensshserver-class) class.

##### `namevar` (required)
An arbitrary identifier for the instance unless the *filename* parameter is not set in which case this must provide the value normally set with the *filename* parameter.

##### `content`
Literal content for the drop-in configuration file.  If neither `content` nor `source` is given, the content of the file will be left unmanaged, though file ownership, mode, SELinux context, etc. will continue to be managed.

##### `ensure`
Either `'present'` (default) or `'absent'`.

##### `filename`
Name to be given to the file, without any path details.  A suffix of `'.conf'` is implied and forced.  This may be used in place of *namevar* if it's beneficial to give *namevar* an arbitrary value.

##### `group`
File group account.  Defaults to `'root'` which is appropriate for most files.

##### `source`
URI of the drop-in configuration file content.  If neither `content` nor `source` is given, the content of the file will be left unmanaged, though file ownership, mode, SELinux context, etc. will continue to be managed.

##### `mode`
File access mode.  Defaults to `'0600'` which is appropriate for most files.

##### `owner`
File owner account.  Defaults to `'root'` which is appropriate for most files.


### Data types

### Facts

### Functions


#### openssh::ipaddresses function

Returns all IP addresses of all network interfaces found by facter.  This requires a single argument specifying an array of interface name prefixes to be excluded, e.g., `['lo', 'tun']`.


## Limitations

Tested on modern Fedora and CentOS releases, but likely to work on any Red Hat variant.  Adaptations for other operating s

This module requires Puppet 4 or later.

## Development

Contributions are welcome via pull requests.  All code should generally be compliant with puppet-lint.
