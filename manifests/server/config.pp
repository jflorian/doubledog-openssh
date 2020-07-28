#
# == Define: openssh::server::config
#
# Manages a drop-in configuration file for the OpenSSH server.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-openssh Puppet module.
# Copyright 2020 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


define openssh::server::config (
        Ddolib::File::Ensure::Limited   $ensure='present',
        String[1]                       $filename=$title,
        String[1]                       $owner='root',
        String[1]                       $group='root',
        Pattern[/[0-7]{4}/]             $mode='0600',
        Optional[String[1]]             $content=undef,
        Optional[String[1]]             $source=undef,
    ) {

    include 'openssh::server'

    file { "${openssh::server::include_dir}/${filename}.conf":
        ensure  => $ensure,
        owner   => $owner,
        group   => $group,
        mode    => $mode,
        seluser => 'system_u',
        selrole => 'object_r',
        seltype => 'httpd_config_t',
        content => $content,
        source  => $source,
        require => Package[$openssh::server::packages],
        before  => Service[$openssh::server::service],
        notify  => Service[$openssh::server::service],
    }

}
