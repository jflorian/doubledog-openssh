#
# == Function: openssh::ipaddresses
#
# Returns all IP addresses of all network interfaces (except lo) found by
# facter.
#
# === Authors
#
#   Steffen Zieger <github@saz.sh>
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-openssh Puppet module.
# Copyright 2014-2018 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Based heavily on source from https://github.com/saz/puppet-ssh
# Copyright 2011 Steffen Zieger


Puppet::Functions.create_function(:'openssh::ipaddresses') do
    dispatch :ipaddresses do
        return_type 'Array[String]'
    end

    def ipaddresses()
        scope = closure_scope
        interfaces = scope['facts']['interfaces'].split(',')

        result = []
        interfaces.each do |iface|
            next if iface.include?('lo')
            ipaddr = scope['facts']["ipaddress_#{iface}"]
            ipaddr6 = scope['facts']["ipaddress6_#{iface}"]
            result << ipaddr if ipaddr && (ipaddr != :undefined)
            result << ipaddr6 if ipaddr6 && (ipaddr6 != :undefined)
        end
        result
    end

end
