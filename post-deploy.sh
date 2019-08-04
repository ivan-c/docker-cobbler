#!/bin/sh
set -eu

# run this script after starting containers

print_dotenv_value(){
    # print value of first matching key in .env
    local env_file=./.env
    local variable_name=$1

    grep --max-count 1 "^$variable_name=" "$env_file" | cut --delimiter '=' --fields 2-
}


cobbler='docker-compose exec cobblerd cobbler'

echo rebuilding configs...
$cobbler sync

echo importing extracted images...
for extracted_image_dir in media/*; do
    test -d "$extracted_image_dir" || continue
    image_name="$(basename $extracted_image_dir)"

    echo importing $extracted_image_dir
    $cobbler import \
        --path="$extracted_image_dir" \
        --name="$image_name"
done

TEST_MAC="$(print_dotenv_value TEST_MAC)"
TEST_PROFILE="$(print_dotenv_value TEST_PROFILE)"

$cobbler system add \
    --name=test \
    --interface=eth0 \
    --profile=$TEST_PROFILE \
    --mac=$TEST_MAC

$cobbler sync

docker-compose restart cobbler-dnsmasq
