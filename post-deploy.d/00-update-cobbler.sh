#!/bin/sh
set -eu

echo updating available systems...
cobbler signature update
cobbler get-loaders
