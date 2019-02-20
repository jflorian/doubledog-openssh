#
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
# Copyright 2013-2019 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


class openssh::hostkeys (
        Array[String[1]]    $aliases,
        Array[String[1]]    $exclude_interfaces,
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

    $ipaddresses = openssh::ipaddresses($exclude_interfaces)
    $host_aliases = [$::fqdn, $::hostname, $aliases, $ipaddresses]

    # Export all types of host keys from this host.  Types are given as first
    # field for each public key in /etc/ssh/ssh_host_*_key.pub.  The
    # conditions however are based on variables provided by facter.  For those
    # running "facter | grep ssh.*key" can be useful.
    if $::sshrsakey {
        openssh::known_host { "${::fqdn}_rsa":
            aliases => $host_aliases,
            key     => $::sshrsakey,
            type    => 'rsa',
        }
    }

    if $::sshecdsakey {
        openssh::known_host { "${::fqdn}_ecdsa":
            aliases => $host_aliases,
            key     => $::sshecdsakey,
            type    => 'ecdsa-sha2-nistp256',
        }
    }

    if $::sshed25519key {
        openssh::known_host { "${::fqdn}_ed25519":
            aliases => $host_aliases,
            key     => $::sshed25519key,
            type    => 'ed25519',
        }
    }

    # Import all host keys from the other hosts.
    Sshkey <<| |>>

    # Remove any host keys that are not managed by Puppet.
    resources  { 'sshkey':
        purge => $purge_keys,
    }

}
