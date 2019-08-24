#!/bin/sh
set -eu

# download Debian PXE files

: "${debian_release:?Variable not set or empty}"

mirror_base=https://mirrors.edge.kernel.org
mirror_path=/debian/dists/${debian_release}/main/installer-amd64/current/images/netboot/debian-installer/amd64/

pxe_dir=/media/debian-${debian_release}-pxe

mkdir --parents $pxe_dir

for pxe_filename in initrd.gz linux; do
    test ! -f "${pxe_dir}/${pxe_filename}" || continue

    curl \
        "${mirror_base}${mirror_path}/${pxe_filename}" \
        -o "${pxe_dir}/${pxe_filename}"
done
