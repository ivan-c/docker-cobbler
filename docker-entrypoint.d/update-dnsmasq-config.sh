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
