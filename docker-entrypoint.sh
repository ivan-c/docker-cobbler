#!/bin/sh

set -eu

DIR=/docker-entrypoint.d

if [ -d "$DIR" ]; then
    run-parts --verbose "$DIR"
fi


update_setting() {
    # update a setting in /etc/cobbler/settings
    local setting_name="$1"
    local setting_value="$2"

    local default_settings_file=/etc/cobbler/settings
    local settings_file="${3:-$default_settings_file}"

    sed  -i -e '/^'$setting_name'/ s/:.*$/: '$setting_value'/' $settings_file
}


# update cobblerd host
update_setting server cobblerd
update_setting manage_dhcp 1
update_setting manage_dns 1

sed 's|module = manage_bind|module = manage_dnsmasq|' -i /etc/cobbler/modules.conf
sed 's|module = manage_isc|module = manage_dnsmasq|' -i /etc/cobbler/modules.conf


for iso_file in /media/*.iso; do
    file_basename="$(basename --suffix .iso $iso_file)"
    test -e "$iso_file" || continue
    test ! -d "/media/$file_basename" || continue

    echo extracting $iso_file $file_basename
    xorriso -osirrox on -indev "$iso_file" -extract / "/media/$file_basename"
done


echo entrypoint script complete
echo executing $@
exec "$@"
