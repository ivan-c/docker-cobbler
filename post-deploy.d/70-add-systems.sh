#!/bin/sh
set -eu

imported_systems="$(cobbler system list)"
if echo "$imported_systems" | grep --quiet test-system; then exit 0; fi

cobbler system add \
    --name=test-system \
    --interface=eth0 \
    --profile=$TEST_PROFILE \
    --hostname=$TEST_HOSTNAME \
    --mac=$TEST_MAC
# NB domain is populated from hostname
