# modules/openssh/manifests/params.pp
#
# == Class: openssh::params
#
# Parameters for the openssh puppet module.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2012-2016 John Florian


class openssh::params {

    case $::operatingsystem {

        'CentOS', 'Fedora': {

            $services = 'sshd'
            $packages = 'openssh-server'

        }

        default: {
            fail ("${title}: operating system '${::operatingsystem}' is not supported")
        }

    }

}
