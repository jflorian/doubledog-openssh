# modules/MODULE_NAME/manifests/params.pp
#
# Synopsis:
#       Parameters for the MODULE_NAME puppet module.


class MODULE_NAME::params {

    case $::operatingsystem {
        Fedora: {

            $services = [
                'SERVICE_NAME',
            ]
            $packages = [
                'PACKAGE_NAME',
            ]

        }

        default: {
            fail ("The MODULE_NAME module is not yet supported on ${operatingsystem}.")
        }

    }

}
