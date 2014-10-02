# modules/openssh/manifests/init.pp
#
# Synopsis:
#       Configures a host as a OpenSSH server.
#
# Parameters:
#       Name__________  Notes_  Description___________________________
#
#       config                  sshd_config as a string.


class openssh::server ($config=undef) {

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
        content => $config,
    }

    iptables::tcp_port {
        'sshd': port => '22';
    }

    service { $openssh::params::services:
        ensure      => running,
        enable      => true,
        hasrestart  => true,
        hasstatus   => true,
    }

}
