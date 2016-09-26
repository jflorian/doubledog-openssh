# modules/openssh/manifests/hostkeys.pp
#
# == Class: openssh::hostkeys
#
# Manages host keys for the OpenSSH server.
#
# === Parameters
#
# ==== Required
#
# ==== Optional
#
# [*aliases*]
#   A list of other valid identities for this host.  By default, the hostkey
#   of each type will be associated with the short hostname (e.g., 'burmese'),
#   the fully-qualified hostname (e.g., 'burmese.python.org') and its primary
#   (as determined by facter) IP address.
#
# [*purge_keys*]
#   If true (the default), then purge any and all SSH hostkeys existing in the
#   system-wide known_hosts file that are not managed by Puppet.  This has no
#   effect on any other known_hosts files such as those per user.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2013-2016 John Florian


class openssh::hostkeys (
        $aliases=undef,
        $purge_keys=true,
    ) inherits ::openssh::params {

    validate_bool($purge_keys)

    File {
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        seluser => 'system_u',
        selrole => 'object_r',
        seltype => 'etc_t',
    }

    # Make sure the known_hosts file is readable by non-root users.  See
    # http://projects.reductivelabs.com/issues/2014.
    file { '/etc/ssh/ssh_known_hosts':
    }

    $ipaddresses = ipaddresses()
    if $aliases == undef {
        $host_aliases = flatten([$::hostname, $ipaddresses])
    } else {
        $host_aliases = flatten([$::hostname, $aliases, $ipaddresses])
    }

    Sshkey {
        host_aliases    => $host_aliases,
        require         => Class['openssh::server'],
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
