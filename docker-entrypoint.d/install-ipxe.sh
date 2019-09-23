#!/bin/sh
set -eu

# install iPXE files
# todo: run at image build instead of post-deploy

TFTP_ROOT=/var/lib/tftpboot
mirror='https://boot.ipxe.org'

echo installing iPXE files...
for ipxe_filename in ipxe.efi undionly.kpxe; do
    test ! -f "${TFTP_ROOT}/${ipxe_filename}" || continue

    curl \
        "${mirror}/${ipxe_filename}" \
        --output "${TFTP_ROOT}/${ipxe_filename}"
done
