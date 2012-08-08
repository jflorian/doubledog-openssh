# modules/openssh/manifests/init.pp
#
# Synopsis:
#       Configures a host as a OpenSSH server.
#
# Parameters:
#       Name__________  Default_______  Description___________________________
#
#       config                          sshd_config as a string.


class openssh::server ($config) {

    package { 'openssh-server':
        ensure  => installed,
    }

    file { '/etc/ssh/sshd_config':
        group   => 'root',
        mode    => '0600',
        owner   => 'root',
        require => Package['openssh-server'],
        seluser => 'system_u',
        selrole => 'object_r',
        seltype => 'etc_t',
        content => "${config}",
    }

    lokkit::tcp_port { 'sshd':
        port    => '22',
    }

    service { 'sshd':
        enable          => true,
        ensure          => running,
        hasrestart      => true,
        hasstatus       => true,
        require         => [
            Package['openssh-server'],
        ],
        subscribe       => [
            File['/etc/ssh/sshd_config'],
        ],
    }

}
