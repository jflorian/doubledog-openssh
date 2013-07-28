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

    if $aliases == undef {
        $host_aliases = [$hostname, $ipaddress]
    } else {
        $host_aliases = [$hostname, $aliases, $ipaddress]
    }

    # Export hostkeys from all hosts.
    @@sshkey { $fqdn:
        ensure          => present,
        host_aliases    => $host_aliases,
        type            => 'ssh-rsa',
        key             => $sshrsakey,
        require         => Class['openssh::server'],
    }

    # Import hostkeys to all hosts.
    Sshkey <<| |>>

}
