#!/bin/sh
set -eu


cp --remove-destination --verbose --recursive \
    /var/lib/tftpboot/images \
    /var/www/cobbler/
