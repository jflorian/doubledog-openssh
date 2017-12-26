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


### Classes

#### openssh::hostkeys class

This class manages the public host keys for the OpenSSH server.  It will export all common keys discovered and simultaneously import all previously exported keys so that each is known to the OpenSSH server as a trusted "known host".

Any "known host" keys that are configured for the server, but which are not found as exports, can be automatically deleted.  This behavior eliminates any false or obsolete trust and works best when exported resources are set to auto-expire if not regularly refreshed via constant exort.

##### `aliases`
An array of other valid identities for this host.  By default, the host key of each type will be associated with the short hostname (e.g., `burmese`), the fully-qualified hostname (e.g., `burmese.python.org`) and its primary (as determined by facter) IP address.  If this parameter is set, it's only necessary to specify any other identies as the default identies will be applied regardless.


#### openssh::server class

This class manages the OpenSSH server package installation, configuration and service.

##### `content`
Literal content for the server's configuration file.  If neither `content` nor `source` is given, the content of the file will be left unmanaged, though file ownership, mode, SELinux context, etc. will continue to be managed.

##### `enable`
Instance is to be started at boot.  Either `true` (default) or `false`.

##### `ensure`
Instance is to be `running` (default) or `stopped`.  Alternatively, a Boolean value may also be used with `true` equivalent to `running` and `false` equivalent to `stopped`.

##### `manage_firewall`
A Boolean value indicating whether to manage the firewall or not.  Defaults to `true`.

##### `packages`
An array of package names needed for the OpenSSH server installation.  The default should be correct for supported platforms.

##### `service`
The service names needed for the OpenSSH server.  The default should be correct for supported platforms.

##### `source`
URI of the server's configuration file content.  If neither `content` nor `source` is given, the content of the file will be left unmanaged, though file ownership, mode, SELinux context, etc. will continue to be managed.


### Defined types


## Limitations

Tested on modern Fedora and CentOS releases, but likely to work on any Red Hat variant.  Adaptations for other operating s

This should be compatible with Puppet 3.x and is being used with Puppet 4.x as
well.

## Development

Contributions are welcome via pull requests.  All code should generally be compliant with puppet-lint.
