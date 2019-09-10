#!/bin/sh
set -eu

echo importing extracted images...

imported_distros="$(cobbler distro list)"
for extracted_image_dir in media/*; do
    test -d "$extracted_image_dir" || continue

    # skip if not extracted iso (autorun.inf absent)
    test -f "${extracted_image_dir}/autorun.inf" || continue

    image_name="$(basename $extracted_image_dir)"
    # skip distros that are already imported
    if echo "$imported_distros" | grep --quiet "$image_name"; then continue; fi

    echo importing extracted iso: $extracted_image_dir
    cobbler import \
        --path="$extracted_image_dir" \
        --name="$image_name"
done
