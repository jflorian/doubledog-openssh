# == Class: openssh::server
#
# Manages the OpenSSH server.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2012-2017 John Florian


class openssh::server (
        Boolean                                         $enable,
        Variant[Boolean, Enum['running', 'stopped']]    $ensure,
        Optional[String]                                $content,
        Array[String[1], 1]                             $packages,
        Optional[String[1]]                             $source,
        Boolean                                         $manage_firewall,
        String[1]                                       $service,
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
