#!/bin/sh
set -eu

# run this script after starting containers

print_dotenv_value(){
    # print value of first matching key in .env
    local env_file=./.env
    local variable_name=$1

    grep --max-count 1 "^$variable_name=" "$env_file" | cut --delimiter '=' --fields 2-
}

debian_release="$(docker-compose exec cobblerd printenv debian_release | tr --delete [:space:])"

cobbler='docker-compose exec cobblerd cobbler'

TEST_MAC="$(print_dotenv_value TEST_MAC)"
TEST_PROFILE="$(print_dotenv_value TEST_PROFILE)"
TEST_HOSTNAME="$(print_dotenv_value TEST_HOSTNAME)"
http_proxy="$(print_dotenv_value http_proxy)"
ansible_provision=true

if [ -n "$http_proxy" ]; then
    $cobbler profile add \
        --name=$TEST_PROFILE \
        --distro=debian-${debian_release}-pxe \
        --ksmeta="http_proxy=${http_proxy} ansible_provision=${ansible_provision}" \
        --kickstart=/var/lib/cobbler/kickstarts/sample.seed
else
    $cobbler profile add \
        --name=$TEST_PROFILE \
        --distro=debian-${debian_release}-pxe \
        --ksmeta="ansible_provision=${ansible_provision}" \
        --kickstart=/var/lib/cobbler/kickstarts/sample.seed
fi

$cobbler system add \
    --name=test-system \
    --interface=eth0 \
    --profile=$TEST_PROFILE \
    --hostname=$TEST_HOSTNAME \
    --mac=$TEST_MAC
# NB domain is populated from hostname


$cobbler sync
