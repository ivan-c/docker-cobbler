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

for iso_file in /media/*.iso; do
    test -e "$iso_file" || continue

    file_basename="$(basename --suffix .iso $iso_file)"
    echo extracting $iso_file $file_basename
    xorriso -osirrox on -indev "$iso_file" -extract / "/media/$file_basename"
done


echo entrypoint script complete
echo executing $@
exec "$@"
