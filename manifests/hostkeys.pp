# modules/openssh/manifests/hostkeys.pp
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

    # This function doesn't work across all hosts for some reason.
    #$ipaddresses = ipaddresses()
    # So, nice as it sounds, for now ...
    $ipaddresses = $::ipaddress
    if $aliases == undef {
        $host_aliases = flatten([$::hostname, $ipaddresses])
    } else {
        $host_aliases = flatten([$::hostname, $aliases, $ipaddresses])
    }

    Sshkey {
        host_aliases    => $host_aliases,
        require         => Class['openssh::server'],
    }

    # Export all types of hostkeys from all hosts.
    if $sshdsakey {
        @@sshkey { "${::fqdn}_dsa":
            type    => 'dsa',
            key     => $sshdsakey,
        }
    }

    if $sshrsakey {
        @@sshkey { "${::fqdn}_rsa":
            type    => 'rsa',
            key     => $sshrsakey,
        }
    }

    if $sshecdsakey {
        @@sshkey { "${::fqdn}_ecdsa":
            type    => 'ecdsa-sha2-nistp256',
            key     => $sshecdsakey,
        }
    }

    # Import hostkeys to all hosts.
    Sshkey <<| |>>

}
