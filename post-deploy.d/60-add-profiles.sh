#!/bin/sh
set -eu

imported_profiles="$(cobbler profile list)"
if echo "$imported_profiles" | grep --quiet "$TEST_PROFILE"; then exit 0; fi

ansible_provision=true

if [ -n "$http_proxy" ]; then
    cobbler profile add \
        --name=$TEST_PROFILE \
        --distro=debian-${debian_release}-pxe \
        --ksmeta="http_proxy=${http_proxy} ansible_provision=${ansible_provision}" \
        --kickstart=/var/lib/cobbler/kickstarts/sample.seed
else
    cobbler profile add \
        --name=$TEST_PROFILE \
        --distro=debian-${debian_release}-pxe \
        --ksmeta="ansible_provision=${ansible_provision}" \
        --kickstart=/var/lib/cobbler/kickstarts/sample.seed
fi
