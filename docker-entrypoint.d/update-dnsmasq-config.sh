#!/bin/sh

set -eu

update_setting() {
    # update a setting in /etc/cobbler/dnsmasq.template
    local setting_name="$1"
    local setting_value="$2"
    local default_settings_file=/etc/cobbler/dnsmasq.template
    local settings_file="${3:-$default_settings_file}"

    sed \
        --in-place "$settings_file" \
        --expression '/^'$setting_name'/ s/=.*$/='$setting_value'/'
}

delete_setting(){
    local setting_name="$1"
    local default_settings_file=/etc/cobbler/dnsmasq.template
    local settings_file="${2:-$default_settings_file}"

    sed '/'$setting_name'/d' --in-place $settings_file
}

insert_setting(){
    # insert a setting in /etc/cobbler/dnsmasq.template
    local setting_name="$1"
    local setting_value="$2"
    local default_settings_file=/etc/cobbler/dnsmasq.template
    local settings_file="${3:-$default_settings_file}"

    sed \
        '/$insert_cobbler_system_definitions.*/i '"$setting_name=$setting_value"'' \
        --in-place "$settings_file"
}

echo /etc/cobbler/dnsmasq.template:::
cat /etc/cobbler/dnsmasq.template

settings_file=/etc/cobbler/dnsmasq.template

# https://serverfault.com/q/53116
# http://howto.basjes.nl/linux/doing-pxe-without-dhcp-control
update_setting dhcp-range 192.168.1.0,proxy

delete_setting dhcp-option
delete_setting dhcp-lease-max
delete_setting dhcp-authoritative
delete_setting dhcp-boot

#insert_setting dhcp-ignore '#known'
#insert_setting pxe-service 'x86PC, "Boot PXELinux (=Cobbler controlled)", pxelinux ,$next_server'

echo updated dnsmasq template
