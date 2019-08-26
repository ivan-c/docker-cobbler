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

echo rebuilding configs...
$cobbler sync

echo updating available systems...
$cobbler signature update

echo importing extracted images...
for extracted_image_dir in media/*; do
    test -d "$extracted_image_dir" || continue
    # skip if not extracted iso (autorun.inf absent)
    test -f "${extracted_image_dir}/autorun.inf" || continue

    image_name="$(basename $extracted_image_dir)"

    echo importing extracted iso: $extracted_image_dir
    $cobbler import \
        --path="$extracted_image_dir" \
        --name="$image_name"
done

for extracted_image_dir in media/*; do
    test -d "$extracted_image_dir" || continue
    # skip if not dir of pxe files (initrd.gz absent)
    test -f "${extracted_image_dir}/initrd.gz" || continue


    pxe_dir_name="$(basename $extracted_image_dir)"

    echo importing PXE dir: $extracted_image_dir...

    $cobbler distro add \
        --name="$pxe_dir_name" \
        --kernel="${extracted_image_dir}/linux" \
        --initrd="${extracted_image_dir}/initrd.gz" \
        --arch=x86_64 \
        --breed=debian \
        --os-version=${debian_release}
done


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



$cobbler sync
