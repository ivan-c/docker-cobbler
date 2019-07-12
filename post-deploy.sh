#!/bin/sh
set -eu

# run this script after starting containers


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
