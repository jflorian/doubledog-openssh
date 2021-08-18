<!--
This file is part of the doubledog-openssh Puppet module.
Copyright 2018-2021 John Florian
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

## [1.8.1] WIP
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security
- `include_dir` is group- and world-readable but should be private

## [1.8.0] 2020-12-08
### Added
- support for Fedora 33
- dependency on `puppetlabs/stdlib` now allows version 6
### Removed
- support for Fedora 30-31

## [1.7.1] 2020-07-28
### Fixed
- `openssh::server::config` ignores value of `include_dir`

## [1.7.0] 2020-07-28
### Added
- `openssh::server::config` defined type
- `openssh::server::configs` parameter
- `openssh::server::include_dir` parameter
- support for Fedora 32
### Changed
- `openssh::server` now manages the directory `include_dir` for drop-in config files
- `openssh::server` now creates `openssh::server::config` resources per the `configs` parameter.
### Removed
- support for Fedora 29

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
