#
# == Class: openssh::known_host
#
# Manages a known host key for the OpenSSH server.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-openssh Puppet module.
# Copyright 2019 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


define openssh::known_host (
        Array[Data, 1]                  $aliases,
        String                          $type,
        String[1]                       $key,
        Ddolib::File::Ensure::Limited   $ensure='present',
        String[1]                       $key_name=$title,
    ) {

    @@sshkey { $key_name:
        host_aliases => sort(unique(flatten($aliases))),
        type         => $type,
        key          => $key,
    }

}
