#!/bin/sh
set -eu

# update cobbler settings

update_setting() {
    # update a setting in /etc/cobbler/settings
    local setting_name="$1"
    local setting_value="$2"

    local default_settings_file=/etc/cobbler/settings
    local settings_file="${3:-$default_settings_file}"

    sed \
        --in-place "$settings_file" \
        --expression '/^'$setting_name'/ s/:.*$/: '$setting_value'/'
}

# update cobblerd host
update_setting server "$server"
update_setting next_server "$next_server"

# configure cobbler to only manage tftpd files
update_setting manage_tftpd 1
update_setting manage_dhcp 0
update_setting manage_dns 0
