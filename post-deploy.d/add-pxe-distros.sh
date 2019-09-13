#!/bin/sh
set -eu

echo importing PXE files...
imported_distros="$(cobbler distro list)"
for extracted_image_dir in media/*; do
    test -d "$extracted_image_dir" || continue
    # skip if not dir of pxe files (initrd.gz absent)
    test -f "${extracted_image_dir}/initrd.gz" || continue


    pxe_dir_name="$(basename $extracted_image_dir)"
    # skip distros that are already imported
    if echo "$imported_distros" | grep --quiet "$pxe_dir_name"; then continue; fi

    echo importing PXE dir: $extracted_image_dir...

    $cobbler distro add \
        --name="$pxe_dir_name" \
        --kernel="${extracted_image_dir}/linux" \
        --initrd="${extracted_image_dir}/initrd.gz" \
        --arch=x86_64 \
        --breed=debian \
        --os-version=${debian_release}
done
