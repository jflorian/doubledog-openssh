# modules/openssh/manifests/hostkey.pp
#
# == Define: openssh::hostkey
#
# Manage a OpenSSH host key.
#
# This is similar to the native puppet "sshkey" resource type -- which should
# be used in most cases -- but offers some unique capabilities such as
# deploying the key to non-standard locations.
#
# === Parameters
#
# [*namevar*]
#   Name of the host key files.  The public-key file will be deployed as
#   "${location}/${name}.pub" whereas the private-key file will be named
#   "${location}/${name}".  See also the "location" parameter.
#
# [*ensure*]
#   Instance is to be 'present' (default) or 'absent'.
#
# [*public_content*]
#   Literal content for the public-key file.
#
# [*public_source*]
#   URI of the public-key file content.
#
# [*private_content*]
#   Literal content for the private-key file.
#
# [*private_source*]
#   URI of the private-key file content.
#
# [*location*]
#   File system path to where the key files are deployed.  Defaults
#   to "/etc/ssh" which is appropriate for most key files.  See also the
#   "namevar" parameter.
#
# === Authors
#
#   John Florian <john.florian@dart.biz>


define openssh::hostkey (
        $ensure='present',
        $public_content=undef,
        $public_source=undef,
        $private_content=undef,
        $private_source=undef,
        $location='/etc/ssh',
    ) {

    File {
        ensure  => $ensure,
        owner   => 'root',
        seluser => 'system_u',
        selrole => 'object_r',
        seltype => 'sshd_key_t',
    }

    file { "${location}/${name}.pub":
        group   => 'root',
        mode    => '0644',
        content => $public_content,
        source  => $public_source,
    }

    file { "${location}/${name}":
        group   => 'ssh_keys',
        mode    => '0640',
        content => $private_content,
        source  => $private_source,
    }

}
