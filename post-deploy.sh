#!/bin/sh
set -eu

# run this script after starting containers


cobbler='docker-compose exec cobblerd cobbler'

echo rebuilding configs...
$cobbler sync
