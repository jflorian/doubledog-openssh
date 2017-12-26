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
# Copyright 2013-2017 John Florian


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

    $ipaddresses = ipaddresses()
    if $aliases == undef {
        $host_aliases = flatten([$::fqdn, $::hostname, $ipaddresses])
    } else {
        $host_aliases = flatten([$::fqdn, $::hostname, $aliases, $ipaddresses])
    }

    Sshkey {
        host_aliases    => $host_aliases,
        require         => Class['::openssh::server'],
    }

    # Export all types of hostkeys from all hosts.  Types are given as first
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

    # Import hostkeys to all hosts.
    Sshkey <<| |>>

    # Remove any hostkeys that are not managed by Puppet.
    resources  { 'sshkey':
        purge => $purge_keys,
    }

}
