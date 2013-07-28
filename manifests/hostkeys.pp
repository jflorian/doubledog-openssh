# modules/openssh/manifests/init.pp
#
# Synopsis:
#       Configures known host keys for the OpenSSH server.
#
# Parameters:
#       Name__________  Notes_  Description___________________________
#
#       NONE


class openssh::hostkeys {

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
        mode    => '0644',
    }

    # Include partial hostname 'app1.site' in hosts like
    # 'app1.site.doubledog.org'.
    $partial_hostname = regsubst($fqdn, '\.doubledog\.org$', '')
    if $partial_hostname == $hostname {
        $host_aliases = [ $ipaddress, $hostname ]
    } else {
        $host_aliases = [ $ipaddress, $hostname, $partial_hostname ]
    }

    # Export hostkeys from all hosts.
    @@sshkey { $fqdn:
        ensure          => present,
        host_aliases    => $host_aliases,
        type            => 'rsa',
        key             => $sshrsakey,
    }

    # Import hostkeys to all hosts.
    Sshkey <<| |>>

}
