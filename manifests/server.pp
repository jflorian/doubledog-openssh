#
# == Class: openssh::server
#
# Manages the OpenSSH server.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-openssh Puppet module.
# Copyright 2012-2020 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


class openssh::server (
        Boolean                 $enable,
        Ddolib::Service::Ensure $ensure,
        Optional[String]        $content,
        Array[String[1], 1]     $packages,
        Optional[String[1]]     $source,
        Boolean                 $manage_firewall,
        String[1]               $service,
        String[1]               $include_dir='/etc/ssh/sshd_config.d',
        Hash[String[1], Hash]   $known_hosts,
        Hash[String[1], Hash]   $configs,
    ) {

    package { $packages:
        ensure => installed,
        notify => Service[$service],
    }

    file {
        default:
            owner     => 'root',
            group     => 'root',
            mode      => '0600',
            seluser   => 'system_u',
            selrole   => 'object_r',
            seltype   => 'etc_t',
            before    => Service[$service],
            notify    => Service[$service],
            subscribe => Package[$packages],
            ;
        '/etc/ssh/sshd_config':
            content => $content,
            source  => $source,
            ;
        $include_dir:
            ensure => directory,
            mode   => '0755',
    }

    if $manage_firewall {
        firewall { '200 accept SSH packets':
            dport  => '22',
            proto  => 'tcp',
            state  => 'NEW',
            action => 'accept',
        }
    }

    service { $service:
        ensure     => $ensure,
        enable     => $enable,
        hasrestart => true,
        hasstatus  => true,
    }

    create_resources('openssh::known_host', $known_hosts)
    create_resources('openssh::server::config', $configs)

}
