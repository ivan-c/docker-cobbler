#!/bin/sh
set -eu

# overwrite broken relative symlinks with real files
# todo: fixup symlinking/volumes
cp --remove-destination --verbose --recursive \
    /var/lib/tftpboot/images \
    /var/www/cobbler/
