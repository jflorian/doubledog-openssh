# == Class: openssh::server
#
# Manages the OpenSSH server.
#
# === Parameters
#
# ==== Required
#
# ==== Optional
#
# [*enable*]
#   Instance is to be started at boot.  Either true (default) or false.
#
# [*ensure*]
#   Instance is to be 'running' (default) or 'stopped'.
#
# [*content*]
#   Literal content for the OpenSSH server's configuration file.  If neither
#   "content" nor "source" is given, the content of the file will be left
#   unmanaged.
#
# [*source*]
#   URI of the OpenSSH server's configuration file content.  If neither
#   "content" nor "source" is given, the content of the file will be left
#   unmanaged.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2012-2017 John Florian


class openssh::server (
        $enable=true,
        $ensure='running',
        $content=undef,
        Array[String[1], 1]         $packages,
        $source=undef,
        $manage_firewall=true,
        String[1]                   $service,
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

}
