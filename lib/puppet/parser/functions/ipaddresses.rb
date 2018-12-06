#
# == Function: ipaddresses
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


module Puppet::Parser::Functions
  newfunction(:ipaddresses, type: :rvalue, doc: <<-EOS
Returns all ip addresses of network interfaces (except lo) found by facter.
EOS
  ) do |_args|
    interfaces = lookupvar('interfaces')

    # In Puppet v2.7, lookupvar returns :undefined if the variable does
    # not exist.  In Puppet 3.x, it returns nil.
    # See http://docs.puppetlabs.com/guides/custom_functions.html
    return false if interfaces.nil? || interfaces == :undefined

    result = []
    if interfaces.count(',') > 0
      interfaces = interfaces.split(',')
      interfaces.each do |iface|
        next if iface.include?('lo')
        ipaddr = lookupvar("ipaddress_#{iface}")
        ipaddr6 = lookupvar("ipaddress6_#{iface}")
        result << ipaddr if ipaddr && (ipaddr != :undefined)
        result << ipaddr6 if ipaddr6 && (ipaddr6 != :undefined)
      end
    else
      unless interfaces.include?('lo')
        ipaddr = lookupvar("ipaddress_#{interfaces}")
        ipaddr6 = lookupvar("ipaddress6_#{interfaces}")
        result << ipaddr if ipaddr && (ipaddr != :undefined)
        result << ipaddr6 if ipaddr6 && (ipaddr6 != :undefined)
      end
    end

    return result
  end
end
