#!/bin/sh
set -eu

# extract each iso to a separate directory

for iso_file in /media/*.iso; do
    file_basename="$(basename --suffix .iso $iso_file)"
    test -e "$iso_file" || continue
    test ! -d "/media/$file_basename" || continue

    echo extracting $iso_file $file_basename
    xorriso -osirrox on -indev "$iso_file" -extract / "/media/$file_basename"
done
