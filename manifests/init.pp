# modules/openssh/manifests/init.pp
#
# Synopsis:
#       Configures a host as a OpenSSH server.
#
# Parameters:
#       Name__________  Default_______  Description___________________________
#
#       NONE
#
# Requires:
#       NONE
#
# Example usage:
#
#       include openssh::server

class openssh::server {

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
        source  => [
            "puppet:///private-host/openssh/sshd_config",
            "puppet:///private-domain/openssh/sshd_config",
            "puppet:///modules/openssh/sshd_config",
        ],
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
