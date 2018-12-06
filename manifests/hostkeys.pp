# == Class: openssh::hostkeys
#
# Manages host keys for the OpenSSH server.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-openssh Puppet module.
# Copyright 2013-2018 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


class openssh::hostkeys (
        Array[String[1]]    $aliases,
        Boolean             $purge_keys,
    ) {

    file {
        default:
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            seluser => 'system_u',
            selrole => 'object_r',
            seltype => 'etc_t',
            ;
        '/etc/ssh/ssh_known_hosts':
            ;
    }

    $ipaddresses = openssh::ipaddresses()
    $host_aliases = sort(flatten([$::fqdn, $::hostname, $aliases, $ipaddresses]))

    Sshkey {
        host_aliases => $host_aliases,
        require      => Class['::openssh::server'],
    }

    # Export all types of host keys from this host.  Types are given as first
    # field for each public key in /etc/ssh/ssh_host_*_key.pub.  The
    # conditions however are based on variables provided by facter.  For those
    # running "facter | grep ssh.*key" can be useful.
    if $::sshrsakey {
        @@sshkey { "${::fqdn}_rsa":
            type => 'rsa',
            key  => $::sshrsakey,
        }
    }

    if $::sshecdsakey {
        @@sshkey { "${::fqdn}_ecdsa":
            type => 'ecdsa-sha2-nistp256',
            key  => $::sshecdsakey,
        }
    }

    if $::sshed25519key {
        @@sshkey { "${::fqdn}_ed25519":
            type => 'ssh-ed25519',
            key  => $::sshed25519key,
        }
    }

    # Import all host keys from the other hosts.
    Sshkey <<| |>>

    # Remove any host keys that are not managed by Puppet.
    resources  { 'sshkey':
        purge => $purge_keys,
    }

}
