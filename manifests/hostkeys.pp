# modules/openssh/manifests/init.pp
#
# Synopsis:
#       Configures known host keys for the OpenSSH server.
#
# Parameters:
#       Name__________  Notes_  Description___________________________
#
#       aliases         1       Other valid identities for this host.
#
# Notes:
#
#       1.  By default, the hostkey will be associated with the short
#       hostname (e.g., 'burmese'), the fully-qualified hostname (e.g.,
#       'burmese.python.org') and its primary (as determiend by facter) IP
#       address.


class openssh::hostkeys ($aliases=undef) {

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
        $host_aliases = flatten([$::fqdn, $::hostname, $ipaddresses])
    } else {
        $host_aliases = flatten([$::fqdn, $::hostname, $aliases, $ipaddresses])
    }

    # Export all types of hostkeys from all hosts.
    @@sshkey { "${::fqdn}_dsa":
        host_aliases    => $host_aliases,
        type            => 'dsa',
        key             => $sshrsakey,
        require         => Class['openssh::server'],
    }

    @@sshkey { "${::fqdn}_rsa":
        host_aliases    => $host_aliases,
        type            => 'rsa',
        key             => $sshrsakey,
        require         => Class['openssh::server'],
    }

    @@sshkey { "${::fqdn}_ecdsa":
        host_aliases    => $host_aliases,
        type            => 'ecdsa-sha2-nistp256',
        key             => $sshrsakey,
        require         => Class['openssh::server'],
    }

    # Import hostkeys to all hosts.
    # Disabled due to bug:
    #   http://projects.puppetlabs.com/issues/17798
    Sshkey <<| |>>

}
