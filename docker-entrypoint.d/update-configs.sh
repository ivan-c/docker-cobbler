#!/bin/sh

set -eu

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
update_setting server cobblerd

