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

* [openssh::server](#opensshserver-class)

**Defined types:**


### Classes

#### openssh::server class

This class manages the OpenSSH server package installation, configuration and service.

##### `enable`
Instance is to be started at boot.  Either `true` (default) or `false`.

##### `ensure`
Instance is to be `running` (default) or `stopped`.  Alternatively, a Boolean value may also be used with `true` equivalent to `running` and `false` equivalent to `stopped`.

##### `packages`
An array of package names needed for the OpenSSH server installation.  The default should be correct for supported platforms.

##### `service`
The service names needed for the OpenSSH server.  The default should be correct for supported platforms.


### Defined types


## Limitations

Tested on modern Fedora and CentOS releases, but likely to work on any Red Hat variant.  Adaptations for other operating s

This should be compatible with Puppet 3.x and is being used with Puppet 4.x as
well.

## Development

Contributions are welcome via pull requests.  All code should generally be compliant with puppet-lint.
