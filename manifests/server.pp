# modules/openssh/manifests/server.pp
#
# == Class: openssh::server
#
# Configures a host as an OpenSSH server.
#
# === Parameters
#
# [*content*]
#   Literal content for the openssh server configuration file.  One and only
#   one of "content" or "source" must be given.
#
# [*source*]
#   URI of the openssh server configuration file content.  One and only one of
#   "content" or "source" must be given.
#
# [*manage_firewall*]
#   If true, open the SSH port on the firewall.  Otherwise the firewall is
#   left unaffected.  Defaults to true.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#   John Florian <john.florian@dart.biz>


class openssh::server (
        $content=undef,
        $source=undef,
        $manage_firewall=true,
    ) {

    include 'openssh::params'

    package { $openssh::params::packages:
        ensure  => installed,
        notify  => Service[$openssh::params::services],
    }

    File {
        owner       => 'root',
        group       => 'root',
        mode        => '0600',
        seluser     => 'system_u',
        selrole     => 'object_r',
        seltype     => 'etc_t',
        before      => Service[$openssh::params::services],
        notify      => Service[$openssh::params::services],
        subscribe   => Package[$openssh::params::packages],
    }

    file { '/etc/ssh/sshd_config':
        content     => $content,
        source      => $source,
    }

    if $manage_firewall {
        firewall { '200 accept SSH packets':
            dport       => '22',
            proto       => 'tcp',
            state       => 'NEW',
            action      => 'accept',
        }
    }

    service { $openssh::params::services:
        ensure      => running,
        enable      => true,
        hasrestart  => true,
        hasstatus   => true,
    }

}
