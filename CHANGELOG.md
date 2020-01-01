<!--
This file is part of the doubledog-openssh Puppet module.
Copyright 2018-2020 John Florian
SPDX-License-Identifier: GPL-3.0-or-later

Template

## [VERSION] WIP
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security

-->

# Change log

All notable changes to this project (since v1.2.0) will be documented in this file.  The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [1.6.0] 2020-01-01
### Added
- support for EL8
- support for Fedora 29-31
### Changed
- dependency on `puppetlabs/firewall` now allows version 2
### Removed
- support for Fedora 27-28

## [1.5.0] 2019-02-20
### Added
- `openssh::known_host` defined type
- `openssh::server::known_hosts` parameter

## [1.4.0] 2019-01-24
### Changed
- dependency on `doubledog/ddolib` now expects 1 >= version < 2

## [1.3.0] 2018-12-16
### Changed
- puppetlabs-stdlib dependency now allows version 5

## [1.2.0 and prior] 2018-12-15

This and prior releases predate this project's keeping of a formal CHANGELOG.  If you are truly curious, see the Git history.
