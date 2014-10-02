# modules/openssh/manifests/params.pp
#
# Synopsis:
#       Parameters for the openssh puppet module.


class openssh::params {

    case $::operatingsystem {
        Fedora: {

            $services = [
                'sshd',
            ]
            $packages = [
                'openssh-server',
            ]

        }

        default: {
            fail ("The openssh module is not yet supported on ${::operatingsystem}.")
        }

    }

}
