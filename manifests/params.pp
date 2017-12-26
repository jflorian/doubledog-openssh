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
# Copyright 2012-2017 John Florian


class openssh::params {

    case $::operatingsystem {

        'CentOS', 'Fedora': {

            $services = 'sshd'

        }

        default: {
            fail ("${title}: operating system '${::operatingsystem}' is not supported")
        }

    }

}
