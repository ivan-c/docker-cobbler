#!/bin/sh

set -eu

DIR=/docker-entrypoint.d

if [ -d "$DIR" ]; then
    run-parts --verbose "$DIR"
fi

# update cobblerd host
sed  -i -e '/^server/ s/:.*$/: cobblerd/' /etc/cobbler/settings

for iso_file in /media/*.iso; do
    test -e "$iso_file" || continue

    file_basename="$(basename --suffix .iso $iso_file)"
    echo extracting $iso_file $file_basename
    xorriso -osirrox on -indev "$iso_file" -extract / "/media/$file_basename"
done


echo entrypoint script complete
echo executing $@
exec "$@"
